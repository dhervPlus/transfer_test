//
//  Beacon.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Beacon: Decodable {
    var id: Int
    var x: Double
    var y: Double
    var map_id: String
    var created_at: String
    var updated_at: String
    var abs_height: Int
    var latitude: Int
    var name: String
    var loco_beacon_id: String
    var height: Int
    var longitude: Int
}
