//
//  RadiationService.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation
import BeacrewLoco


struct Radiation {
    var s: Vector
    var d: Double
}

struct RadiationService {
    var CM2M: Double = 0.01;
     var VERSION = 15.1;
     var PX2M: Double {
        return 1.0 * CM2M;
     }
    /**
     Build a radiation object from beacon 
     - parameter BCLBeacon: beacon from beacrew loco sdk
     - returns: Radiation
     */
    public func fromBeaconLog(beacon: BCLBeacon) -> Radiation {
        let v = Vector(x: Double(beacon.x) * CM2M * PX2M, y: Double(beacon.y) * CM2M * PX2M, z: Double(beacon.height) * CM2M * PX2M)
        return Radiation(
            s: v,
            d: pow((Double((beacon.txPower - beacon.rssi)) / 20.0), 10)
        )
    }
}
