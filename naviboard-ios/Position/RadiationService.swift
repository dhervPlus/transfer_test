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
    /**
     Build a radiation object from beacon 
     - parameter BCLBeacon: beacon from beacrew loco sdk
     - returns: Radiation
     */
    public func fromBeaconLog(beacon: BCLBeacon) -> Radiation {
        let v = Vector(x: Double(beacon.x), y: Double(beacon.y), z: Double(beacon.height))
        return Radiation(
            s: v,
            d: pow((Double((beacon.txPower - beacon.rssi)) / 20.0), 10)
        )
    }
}
