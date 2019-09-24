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

struct Estimate {
    var x: Decimal
    var y: Decimal
    var z: Decimal
}

struct EstimationService {
    var radiationService: RadiationService;
    var cluster: Cluster = Cluster(cm_per_pixel: 1.0);
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
        var center: Vector = self.getCenter(rads: rads)
        
        
        // use spring to generate location
        var springs = rads.map({(val: Radiation) -> Spring in Spring(source: val.s, lastLocated: center, length: val.d, head: center.sub(v: val.s))});
        
        
        // Max iteration and spring mapping
        var maxIter = 500;
        while(maxIter > 0) {
        var sum = Vector.sum(v_array: springs.map { val in
                var v = val
                return v.force
            })
            var next = sum.mul(a: 0.01);
            next.z = 0.0; // ignore z-axis force.

            springs = springs.map{ val in
                var a = val
                return a.drag(diff: sum)
            };

            if next.length < (0.0001) {
                break
            };
            maxIter -= 1
        }
        
        // get location
        let location = springs[0].location
        
        return Estimate(x: Decimal(location.x), y: Decimal(location.y), z: Decimal(self.userHeightCM) );
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
