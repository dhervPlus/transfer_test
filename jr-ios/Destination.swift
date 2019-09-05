//
//  Destination.swift
//  jr-ios
//
//  Created by damien on 2019/08/23.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class MapData: Decodable {
    
    //MARK: Properties
    var map: Map
    var nodes: [Node]
    var edges: [Edge]
    var destinations: [Destination]
    var guidePlates: [GuidePlate]
    var beacons: [Beacon]
    
    //MARK: Initialization
    init?(    map: Map,
              nodes: [Node],
              edges: [Edge],
              destinations: [Destination],
              guidePlates: [GuidePlate],
              beacons: [Beacon]) {
        
        // Initialize stored properties.
        self.map = map
        self.nodes = nodes
        self.edges = edges
        self.destinations = destinations
        self.guidePlates = guidePlates
        self.beacons = beacons
    }
}

class Node: Decodable {
    var id: Int
    var x: Double
    var y: Double
    init?(id:Int, x: Double, y: Double) {
        self.id = id
        self.x = x
        self.y = y
    }
}
class Edge: Decodable {
    var id: Int
    var node_start_id: Int
    var node_end_id: Int
    init?(id:Int, node_start_id:Int, node_end_id:Int) {
        self.id = id
        self.node_start_id = node_start_id
        self.node_end_id = node_end_id
    }
    
}
class GuidePlate: Decodable {
    
}
class Beacon: Decodable {
    var x: Int
    var y: Int
    init?(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
}
class Map: Decodable {
    
    //MARK: Properties
    var id: Int
    var loco_map_id: String
    var client_id:String
    var name: String
    var image: URL
    var created_at: String
    var updated_at: String
    
    //MARK: Initialization
    
    init?(  id: Int,
            loco_map_id: String,
            client_id:String,
            name: String,
            image: URL,
            created_at: String,
            updated_at: String) {
        
        // Initialize stored properties.
        self.id = id
        self.loco_map_id = loco_map_id
        self.client_id = client_id
        self.name = name
        self.image = image
        self.created_at = created_at
        self.updated_at = updated_at
    }
}

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

class Path {
    
    //MARK: Properties
    
    var id: Int
    var icon: UIImage
    var arrow: UIImage
    var bg: UIImage
    
    
    //MARK: Initialization
    
    init?(id: Int, icon: UIImage, arrow: UIImage, bg: UIImage) {
        
        // Initialize stored properties.
        self.id = id
        self.icon = icon
        self.arrow = arrow
        self.bg = bg
    }
}
