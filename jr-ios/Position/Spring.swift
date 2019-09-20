//
//  Spring.swift
//  jr-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Spring {
    var source: Vector //val.s
    var lastLocated: Vector // center
    var length: Decimal; //val.s
    
    
    
    var head: Vector
    {
        mutating get {return lastLocated.sub(v: source)}
        mutating set {
            
        }
    }
    var location: Vector {
        mutating get {
//            print("LOCATION", source, head, lastLocated)
            
            return source.add(v: head);
        }
        
    }
    
    var force: Vector {
        mutating get {
            var f = Vector(x: self.head.x, y: self.head.y, z: self.head.z);
            f.length = self.length - self.head.length;
            if (1.0 <= self.length) {
                f.mul(a: Double(truncating: (1.0 / self.length) as NSNumber))
            }
            return f;
        }
        mutating set {}
    }
    
    /**
     * returns current spring force as Vector
     */
    //    private mutating func force() -> Vector {
    //
    //       }
    
    /**
     * updates spring head (source and default length should not be changed)
     */
    mutating func drag(diff: Vector) -> Spring {
        self.head = self.head.add(v: diff);
        return self;
    }
}
