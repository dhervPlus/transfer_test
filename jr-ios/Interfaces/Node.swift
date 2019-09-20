//
//  Node.swift
//  jr-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Node: Decodable {
    var id: Int
    var x: Double
    var y: Double
    init?(id:Int, x: Double, y: Double) {
        self.id = id
        self.x = x
        self.y = y
    }
}
