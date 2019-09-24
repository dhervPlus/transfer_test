//
//  Map.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/20.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation


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
