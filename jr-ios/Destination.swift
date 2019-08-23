//
//  Destination.swift
//  jr-ios
//
//  Created by damien on 2019/08/23.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class Destination {
    
    //MARK: Properties
    
    var id: String
    var node_id: String
    var type_id: String
    var label_japanese: String
    var label_english: String
    var label_korean: String
    var label_chinese: String
    
    //MARK: Initialization
     
    init?(id: String, node_id: String, type_id: String, label_japanese: String, label_english: String, label_korean: String, label_chinese: String) {
        
        // Initialize stored properties.
        self.id = id
        self.node_id = node_id
        self.type_id = type_id
        self.label_japanese = label_japanese
        self.label_english = label_english
        self.label_korean = label_korean
        self.label_chinese = label_chinese
    }
}
