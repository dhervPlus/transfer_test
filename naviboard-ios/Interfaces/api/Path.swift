//
//  Path.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct PathData: Codable {
    var node_start_id: Int
    var node_end_id: Int
    var distance: Double
    var z: String
    var direction: String
    var first_beacon_id: String?
    var second_beacon_id: String?
    var destination_id: Int?
    var destination: Destination?
}
