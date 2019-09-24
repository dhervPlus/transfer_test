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
    {
        /**
         Substract vector source from lastLocated vector(=center vector)
         */
        mutating get {
            return lastLocated.sub(v: source)
        }
      set{}
    }
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
            var f = Vector(x: self.head.x, y: self.head.y, z: self.head.z);
            f.length = self.length - self.head.length;
            
            if (1.0 <= self.length) {
                f.mul(a: 1.0 / self.length);
            }
            
            return f;
        }
        
    }
    
    mutating func drag(diff: Vector) -> Spring {
       
//        print("HEAD", self.head, "DIFF", diff)
        self.head = self.head.add(v: diff)
        
        return self;
    }
    
}
