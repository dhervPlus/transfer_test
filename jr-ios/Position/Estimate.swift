//
//  Estimate.swift
//  jr-ios
//
//  Created by damien on 2019/09/19.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

struct outRange {
  var  x1: Int
  var  y1: Int
  var  x2: Int
   var y2: Int
}

struct Estimate {
    var version: Decimal;
    var usable: Bool = false;
    var x: Decimal
    var y: Decimal
    var z: Decimal
    var r: Decimal
//    var inSignal: Decimal
//    var outSignal: Decimal
    var v: Decimal
    
          
       
    
    
//    public func estimateOut(r_px: Decimal) {
//        let outCount = 0;
//        let ioTrials = 1000;
//        let range = outRange(x1: 490, y1: 0, x2: 604, y2: 765)
//
//        for i in 0...ioTrials {
//            var a = Int.random(in: 1...1000) * 2 * M_PI;
//            var xt = this.x + r_px * Math.cos(a) * Math.random();
//            var yt = this.y + r_px * Math.sin(a) * Math.random();
//            if ((outRange.x1 <= xt) && (xt <= outRange.x2) &&
//                (outRange.y1 <= yt) && (yt <= outRange.y2)) {
//                outCount += 1;
//            }
//
//        }
//
//        return outCount * 100.0 / ioTrials;
//    }
    
}

