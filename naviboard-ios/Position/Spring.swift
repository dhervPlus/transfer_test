//
//  Spring.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.


import Foundation

// Use a class for Spring to get a reference type instead of the struct value type

class Spring {
    var source: Vector
    var lastLocated: Vector
    var length: Double
    var calculation_head: Vector?
    var head: Vector
    
    init(source: Vector, lastLocated: Vector, length : Double) {
        self.source = source
        self.lastLocated = lastLocated
        self.length = length
        self.head = self.lastLocated.sub(v: self.source)
    }
    
    /**
     Add head vector to source vector
     - returns: Vector
     */
    func location() -> Vector {
        var current = source
        return current.add(v: head);
    }
    
    /**
     Calculate the force of the spring
     - returns: Vector
     */
    func force() -> Vector {
        let head = self.head
        var f = Vector(x: head.x, y: head.y, z: head.z);
        f = f.setLength(l: self.length - head.length) ;
        if self.length >= 1.0 {
            _ = f.mul(a: (1.0 / self.length));
        }
        return f;
    }
    
    /**
     Add difference to the head
     - returns: Spring
     */
    func drag(diff: Vector) -> Spring {
        _ = self.head.add(v: diff)
        return self;
    }
}
