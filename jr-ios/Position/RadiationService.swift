//
//  RadiationService.swift
//  jr-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation
import BeacrewLoco


struct Radiation {
    var s: Vector
    var d: Decimal
}

struct RadiationService {
    public func fromBeaconLog(beacon: BCLBeacon) -> Radiation {
        let v = Vector(x: Double(beacon.x), y: Double(beacon.y), z: Double(beacon.height))
        return Radiation(
            s: v,
            d: pow(Decimal(Double(beacon.txPower - beacon.rssi) / 20.0), 10)
        )

    }
}
