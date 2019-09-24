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
    var length: Double
    var head: Vector
//    {
//        /**
//         Substract vector source from lastLocated vector(=center vector)
//         */
//        mutating get {
//            print(lastLocated, source)
//            return lastLocated.sub(v: source)
//        }
//      set{}
//    }
    var location: Vector {
        /**
         Add head vector to source vector
         */
        mutating get {
            return source.add(v: head);
        }
        
    }
    
    var force: Vector {
        mutating get {
            let head = self.head
            var f = Vector(x: head.x, y: head.y, z: head.z);
            f.length = self.length - head.length;
           
            if (1.0 <= self.length) {
                f.mul(a: (1.0 / self.length));
            }
             
            return f;
        }
        
    }
    
    mutating func drag(diff: Vector) -> Spring {
        
        let head = self.head.add(v: diff)
        self.head = head
        return self;
    }
    
}
