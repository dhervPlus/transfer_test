//
//  Vector.swift
//  jr-ios
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
        get {return Decimal(sqrt(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2)))}
        set(l) {  let s = l > 0 ? l : 1.0
            if (self.length != 0.0) {
                let dl = Double(truncating: (s / self.length) as NSNumber);
                self.mul(a: dl)
            }
        }
    }
    
    
    mutating func add(v: Vector) -> Vector {
        self.x += v.x;
        self.y += v.y;
        self.z += v.z;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    mutating func sub(v: Vector) -> Vector {
        self.x -= v.x;
        self.y -= v.y;
        self.z -= v.z;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    mutating func mul(a: Double = 1.0) -> Vector {
        self.x *= a;
        self.y *= a;
        self.z *= a;
        return Vector(x: self.x, y: self.y, z: self.z);
    }
    
    mutating func inverse() {
        self.mul(a:-1.0);
    }
    
    //    func sum(v_array = []) {
    //        return v_array.reduce((a, b) => a.add(b));
    //    }
    
    mutating func copy() -> Vector {
        return Vector(x:self.x, y:self.y, z:self.z);
    }
}
