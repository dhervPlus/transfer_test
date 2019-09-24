//
//  Beacon.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Beacon: Decodable {
    var x: Int
    var y: Int
    init?(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
