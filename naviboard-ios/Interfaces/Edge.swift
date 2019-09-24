//
//  Edge.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Edge: Decodable {
    var id: Int
    var node_start_id: Int
    var node_end_id: Int
    init?(id:Int, node_start_id:Int, node_end_id:Int) {
        self.id = id
        self.node_start_id = node_start_id
        self.node_end_id = node_end_id
    }
}
