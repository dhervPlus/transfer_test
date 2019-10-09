//
//  Edge.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Edge: Decodable {
    var id: Int
    var node_start_id: Int
    var node_end_id: Int
    var created_at: String
    var updated_at: String
}
