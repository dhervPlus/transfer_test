//
//  NSString.swift
//  naviboard-ios
//
//  Created by damien on 2019/10/10.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

extension NSString {
       func indent(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(
            string: string ,
            attributes: attributes)
    }
}
