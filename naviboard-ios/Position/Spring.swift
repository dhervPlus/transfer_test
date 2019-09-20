//
//  Spring.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Spring {
    var source: Vector
    var lastLocated: Vector
    var length: Decimal
    var head: Vector
    {
        /**
         Substract vector source from lastLocated vector(=center vector)
         */
        mutating get {
            return lastLocated.sub(v: source)
        }
    }
    var location: Vector {
        /**
         Add head vector to source vector
         */
        mutating get {
            return source.add(v: head);
        }
        
    }
    
}
