//
//  Node.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Node: Decodable {
    var id: Int
    var x: Double
    var y: Double
    var z: Double
    var map_id: Int
    var created_at: String
    var updated_at: String
}
