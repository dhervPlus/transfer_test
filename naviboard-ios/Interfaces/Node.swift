//
//  Node.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Node: Decodable {
    var id: Int
    var x: Double
    var y: Double
    var z: Double
    var map_id: Int
    var created_at: String
    var updated_at: String
    init?(id: Int, x: Double, y: Double, z: Double, map_id: Int, created_at: String, updated_at: String) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
        self.map_id = map_id
        self.created_at = created_at
        self.updated_at = updated_at
    }
}
