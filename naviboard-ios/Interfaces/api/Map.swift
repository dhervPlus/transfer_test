//
//  Map.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation


struct Map: Decodable {
    var id: Int
    var loco_map_id: String
    var client_id:String
    var name: String
    var image: URL
    var created_at: String
    var updated_at: String
    var guide_plates_settings_id: Int?
}

struct MapData: Decodable {
    var map: Map
    var nodes: [Node]
    var edges: [Edge]
    var destinations: [Destination]
    var guidePlates: [GuidePlate]
    var beacons: [Beacon]
}
