//
//  Vector.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct Vector {
    var x : Double
    var y : Double
    var z : Double
 
    var length: Double {
        get {
            
            return Double(sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2)))
        }
       
    }
    
    mutating func setLength(l: Double) -> Vector {
          
         //            print("L", l)
         //            var s
         //            if (l != nil) {
         //                s = l
         //            }
                     if (self.length != 0.0) {
                         let dl = Double(truncating: (l / self.length) as NSNumber);
                         self.mul(a: dl)
                     }
                     return self
                 
     }
    
    /**
     Add vector to current one
     - parameter v: Vector
     - returns: new Vector
     */
    mutating func add(v: Vector) -> Vector {
        self.x += v.x;
        self.y += v.y;
        self.z += v.z;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    /**
     Substract vector to current one
     - parameter v: Vector
     - returns: new Vector
     */
    mutating func sub(v: Vector) -> Vector {
        self.x -= v.x;
        self.y -= v.y;
        self.z -= v.z;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    /**
     Multiply vector with current one
     - parameter a: Double - multiplicator
     - returns: new Vector
     */
    mutating func mul(a: Double = 1.0) -> Vector {
        self.x *= a;
        self.y *= a;
        self.z *= a;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    static func sum(v_array: [Vector]) -> Vector {
        
        var result = Vector(x: 0.0, y: 0.0, z: 0.0)
        for v in v_array {
            result = result.add(v: v)
        }
        return result
    }
    
  
    
}
