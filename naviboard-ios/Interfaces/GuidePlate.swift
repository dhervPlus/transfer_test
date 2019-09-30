//
//  GuidePlate.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class GuidePlate: Decodable {
    var id: Int
    var direction: String
    var map_id: Int
    var first_beacon_id: String
    var second_beacon_id: String
    var node_start_id: Int
    var node_end_id: Int
    var created_at: String
    var updated_at: String
    var resolution_x: Int
    var resolution_y: Int
    var display_x: Int
    var display_y: Int
    var coordinate_left_x: Int
    var  coordinate_left_y: Int
    var coordinate_right_x: Int
    var coordinate_right_y: Int
    var position: String
    var display_image: String
    var ad_image: String
    var x: Int
    var y: Int
    init(id: Int,
         direction: String,
         map_id: Int,
         first_beacon_id: String,
         second_beacon_id: String,
         node_start_id: Int,
         node_end_id: Int,
         created_at: String,
         updated_at: String,
         resolution_x: Int,
         resolution_y: Int,
         display_x: Int,
         display_y: Int,
         coordinate_left_x: Int,
         coordinate_left_y: Int,
         coordinate_right_x: Int,
         coordinate_right_y: Int,
         position: String,
         display_image: String,
         ad_image: String,
         x: Int,
         y: Int) {
        self.id = id
        self.direction = direction
        self.map_id = map_id
        self.first_beacon_id = first_beacon_id
        self.second_beacon_id = second_beacon_id
        self.node_start_id = node_start_id
        self.node_end_id = node_end_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.resolution_x = resolution_x
        self.resolution_y = resolution_y
        self.display_x = display_x
        self.display_y = display_y
        self.coordinate_left_x = coordinate_left_x
        self.coordinate_left_y = coordinate_left_y
        self.coordinate_right_x = coordinate_right_x
        self.coordinate_right_y = coordinate_right_y
        self.position = position
        self.display_image = display_image
        self.ad_image = ad_image
        self.x = x
        self.y = y
    }
}
