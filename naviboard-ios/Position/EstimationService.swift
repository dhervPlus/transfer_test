//
//  EstimationService.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation
import BeacrewLoco

struct Cluster {
    var cm_per_pixel: Double
}

struct Estimate: Codable {
    var x: Decimal
    var y: Decimal
    var z: Decimal
}

struct EstimationService {
    var radiationService: RadiationService = RadiationService();
    
    var cluster: Cluster = Cluster(cm_per_pixel: 3.46875);
    var userHeightCM:Double = 120.0;
    var CM2M = 0.01;
    var VERSION = 15.1;
    var PX2M: Double {
        return cluster.cm_per_pixel * CM2M;
    }
    
    /**
     Calculate the current position of the iphone depending of the beacon logs
     - parameter beacons: [BCLBeacon]
     - returns: Estimate
     */
    public func locatePosition(beacons: [BCLBeacon]) -> Estimate {
        
        // generate vector from beacon
        let rads = beacons.map({ (beacon: BCLBeacon) -> Radiation in return RadiationService().fromBeaconLog(beacon: beacon)})
        
        
        // get center position from each vector
        let center: Vector = self.getCenter(rads: rads)
        
//        print("CENTER", center)
        
        
        // use spring to generate location
        var springs = rads.map({(val: Radiation) -> Spring in Spring(source: val.s, lastLocated: center, length: val.d)});
//        print("SPRING", springs)
        
        // Max iteration and spring mapping
        var maxIter = 500;
        
        var mut_springs = [Spring]()
        while(maxIter > 0) {
        var sum = Vector.sum(v_array: springs.map { val in
                var v = val
            return v.force()
            })
        
        
        
            var next = sum.mul(a: 0.01);
            
            next.z = 0.0; // ignore z-axis force.

            mut_springs = springs.map{ val in
                var a = val
                return a.drag(diff: sum)
            };

        
            if next.length < (0.0001) {
                break
            };
            maxIter -= 1
        }
        
//        print("MUT",mut_springs)
        // get location
        var location: Estimate? = nil
        if let firstNumber = mut_springs.first {
            var first = firstNumber
            let firstLoc = first.location()
//            print(first.location)
            
          
                
            location = Estimate(x: Decimal( firstLoc.x), y: Decimal( firstLoc.y), z: Decimal(self.userHeightCM) );
        }
       
        return location!
    }
    
    /**
     Calculate the center position as a vector
     - parameter rads: [Radiation]
     - returns: Vector with center coordinates
     */
    private func getCenter(rads: [Radiation]) -> Vector {
        
        var center:Vector;
        
        // Get vector of each beacon using the Radiation
        let center_array: [Vector] = rads.map({(val: Radiation) -> Vector in return val.s})
        
        
        
        // addition all vector together and divide by their number to get center position
        var initial_center:Vector = Vector(x: 0.0, y: 0.0, z: 0.0)
        for v in center_array {
            initial_center = initial_center.add(v: v)
        }
        center = initial_center.mul(a: 1.0 / Double(rads.count));
        
        center.z = userHeightCM;
        
        return center
    }
}
