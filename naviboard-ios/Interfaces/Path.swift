//
//  Path.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class Path {
    
    //MARK: Properties
    
    var id: Int
    var icon: UIImage
    var arrow: UIImage
    
    
    
    //MARK: Initialization
    
    init?(id: Int, icon: UIImage, arrow: UIImage) {
        
        // Initialize stored properties.
        self.id = id
        self.icon = icon
        self.arrow = arrow
        
    }
}
