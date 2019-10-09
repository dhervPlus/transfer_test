//
//  GuidePlate.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct GuidePlate: Decodable {
    var id: Int
    var direction: String
    var map_id: Int
    var first_beacon_id: String
    var second_beacon_id: String?
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
    var android_id: String
}
