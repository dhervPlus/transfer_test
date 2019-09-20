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
    var length: Decimal {
        get {
            return Decimal(sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2)))
        }
        set(l) {
            let s = l > 0 ? l : 1.0
            if (self.length != 0.0) {
                let dl = Double(truncating: (s / self.length) as NSNumber);
                self.mul(a: dl)
            }
        }
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

}
