//
//  Spring.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/18.
//  Copyright © 2019 beacrew. All rights reserved.
//

//import Foundation
//
//struct Spring {
//    var source: Vector
//    var lastLocated: Vector
//    var length: Double
//    var calculation_head: Vector?
//    var head: Vector
//    {
//        /**
//         Substract vector source from lastLocated vector(=center vector)
//         */
//        mutating get {
//            var center = lastLocated
//
//            return center.sub(v: source)
//        }
//      set{}
//    }
//    var location: Vector {
//        /**
//         Add head vector to source vector
//         */
//        mutating get {
//            var current = source
//              print("CURRETN", lastLocated)
////            let current_head = lastLocated.sub(v: source)
//
//            return current.add(v: lastLocated);
//        }
//
//    }
//
//    var force: Vector {
//        mutating get {
//            let head = lastLocated.sub(v: source)
//            var f = Vector(x: head.x, y: head.y, z: head.z);
//            f = f.setLength(l: self.length - head.length) ;
////            print(f.length, self.length, head.length)
//            if (1.0 <= self.length) {
//                f.mul(a: (1.0 / self.length));
//            }
//
//
//            return f;
//        }
//
//    }
//
//    mutating func drag(diff: Vector) -> Spring {
//
//        var head = lastLocated.sub(v: source)
//        head.add(v: diff)
//        self.calculation_head = head
//        print("HEAD", lastLocated)
//        return self;
//    }
//
//}


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
      
        func location() -> Vector {
            /**
             Add head vector to source vector
             */
            
                var current = source
                  
    //            let current_head = lastLocated.sub(v: source)
            
                return current.add(v: head);
            
            
        }
        
        func force() -> Vector {
            
            let head = self.head
                var f = Vector(x: head.x, y: head.y, z: head.z);
                f = f.setLength(l: self.length - head.length) ;
    //            print(f.length, self.length, head.length)
                if (1.0 <= self.length) {
                    f.mul(a: (1.0 / self.length));
                }
                
                 
                return f;
            }
            
        
        
         func drag(diff: Vector) -> Spring {
            
            self.head.add(v: diff)
          
            
            return self;
        }
        
    
}
