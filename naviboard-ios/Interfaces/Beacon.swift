//
//  Beacon.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Beacon: Decodable {
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
    
    
    init?(id: Int, x: Double, y: Double, map_id: String, created_at: String, updated_at: String,    abs_height: Int,
          latitude: Int,
          name: String,
          loco_beacon_id: String,
          height: Int,
          longitude: Int) {
        self.id = id
        self.x = x
        self.y = y
        
        self.map_id = map_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.abs_height = abs_height
        self.latitude = latitude
        self.name = name
        self.loco_beacon_id = loco_beacon_id
        self.height = height
        self.longitude = longitude
    }
}
