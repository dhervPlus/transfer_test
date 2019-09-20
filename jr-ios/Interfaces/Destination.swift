//
//  Destination.swift
//  jr-ios
//
//  Created by damien on 2019/08/23.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Destination: Decodable {
    
    //MARK: Properties
    
    var id: Int
    var node_id: Int
    var type_id: Int
    var label_japanese: String
    var label_english: String
    var label_korean: String
    var label_chinese: String
    var type_label_japanese: String
    var type_label_english: String
    var type_label_chinese: String
    var type_label_korean: String
    
    //MARK: Initialization
    
    init?(id: Int, node_id: Int, type_id: Int, label_japanese: String, label_english: String, label_korean: String, label_chinese: String, type_label_japanese: String, type_label_english: String,
     type_label_chinese: String,
    type_label_korean: String) {
        
        // Initialize stored properties.
        self.id = id
        self.node_id = node_id
        self.type_id = type_id
        self.label_japanese = label_japanese
        self.label_english = label_english
        self.label_korean = label_korean
        self.label_chinese = label_chinese
        self.type_label_japanese = type_label_japanese
        self.type_label_english = type_label_english
        self.type_label_chinese = type_label_chinese
        self.type_label_korean = type_label_korean
    }
}


