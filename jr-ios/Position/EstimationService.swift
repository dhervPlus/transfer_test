//
//  EstimationService.swift
//  jr-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation
import BeacrewLoco

struct Cluster {
    var cm_per_pixel: Double
}

struct Position {
    var x: Double
    var y: Double
}
struct EstimationService {
    
    var radiationService: RadiationService;
    
    // cluster service allows us to determine information about the 'map'
    var cluster: Cluster = Cluster(cm_per_pixel: 1.0);
    
    var userHeightCM:Double = 120.0;
    
    
    
    public func locatePosition(beacons: [BCLBeacon]) -> Estimate {
        let CM2M = 0.01;
        let VERSION = 15.1;
        
        
        
        // convert beacon to radiation service object {s:..., d:...}
        let rads = beacons.map({ (beacon: BCLBeacon) -> Radiation in return RadiationService().fromBeaconLog(beacon: beacon)})
        
        
        //        if (!rads.length) return new Estimate(self.VERSION);
        
        // get cluster information
        
        // get pixel per meters
        let PX2M = cluster.cm_per_pixel * CM2M;
        
        
        // get center
        var center:Vector;
        //        if (initPos.x > 0.0 && initPos.y > 0.0) {
        // get each item's vector and add them up together and divide by 1/nb_items
        let center_array: [Vector] = rads.map({(val: Radiation) -> Vector in return val.s})
        
        //            var center_reduced:Vector = center_array.reduce(into: Vector) { (a: Vector,b: Vector) -> Vector in a.add(v: b)}
        var center_reduced:Vector = Vector(x: 0.0, y: 0.0, z: 0.0)
        for v in center_array {
            center_reduced = center_reduced.add(v: v)
        }
        center = center_reduced.mul(a: 1.0 / Double(rads.count));
        print("CENTER", center)
        
        
        
        //        } else {
        //            // describe a new vector at position init
        //            center = Vector(x: initPos.x / PX2M, y: initPos.y / PX2M, z: 0.0);
        //        }
        
        // map height to z
        center.z = self.userHeightCM * CM2M * PX2M;
        
        
        
        
        
        //        if (center.x === undefined || center.y === undefined || center.z === undefined ||
        //            isNaN(center.x) || isNaN(center.y) || isNaN(center.z)) {
        //            //console.log(center);
        //            return new Estimate(self.VERSION);
        //        }
        var springs = rads.map({(val: Radiation) -> Spring in Spring(source: val.s, lastLocated: center, length: val.d)});
        
        
        let r = springs.map { (val: Spring) -> Decimal in
            // make a copy of val to avoid immutable errors
            var val = val
            var horizontal_force = val.force;
            horizontal_force.z = 0.0;
            return horizontal_force.length;
        }
        
        
        //          return center
        var result: Decimal = 0.0
        for r_ in r {
            result = result + r_
        }
        //        r = r.reduce(0.0, (a: Decimal,b: Decimal) in a + b)
        result = result  / Decimal(springs.count)
        
        
        
        //        return result
        
        //        .reduce((a, b) => a + b) / springs.length;
//        for spring in springs {
//            var spring = spring
//            print(spring.location)
//        }
        let location = springs[0].location
        let doc = Estimate(version: Decimal(VERSION),usable:true, x: Decimal(location.x), y: Decimal(location.y), z: Decimal(self.userHeightCM), r:result, v: Decimal(VERSION) );
        
        print("DOC", doc)
         
        
        //doc.out = doc.estimateOut(doc.r * PX2M);
        //        doc.in = 100.0 - doc.out;
        //        doc.v = self.VERSION;
        //        doc.usable = true;
        
        return doc;
        
    }
}
