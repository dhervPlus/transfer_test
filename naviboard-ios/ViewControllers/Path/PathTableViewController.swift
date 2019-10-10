//
//  PathTableViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/02.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit
import BeacrewLoco
import SocketIO
import AudioToolbox
import AVFoundation

protocol PathPositionDelegate {
    func setCursorPosition(position: Estimate)
}

class PathTableViewController: UITableViewController, BCLManagerDelegate {
    
    
    // MARK: variables
    
    // from segue
    var pathPositionDelegate: PathPositionDelegate?
    var map: Map? = nil
    var destination_name:String = String()
    var current_table = String()
    var pathData = [Path]()
    
    // from controller
    var get_path_timer_count = 3
    var displayMemory = [Path]()
    var selectedDestination: Destination? = nil
    var alreadySent = [PostSocket]()
    var beacon_ids = [String]()
    var secondBeaconIdsStore = [String]()
    
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BCLManager.shared()?.delegate = self
    }
    
    
    // MARK: BCL functions
    
    func didRangeBeacons(_ beacons: [BCLBeacon]!) {
        checkDisplayInRange(beacons: beacons)
    }
    
    
    // MARK: Private functions
    
    /**
     Check if display items beacon id match one of the beacons in range
     If found, build item and send it through socket to display
     - parameter beacons: [BCLBeacon]
     */
    private func checkDisplayInRange(beacons: [BCLBeacon]) {
        // Check the socket is alived and set it
        socket = Socket.shared.checkAliveSocket()
        
        // Update the get_path_timer_count
        self.get_path_timer_count += 1
        
        // Store the beacons in range with their ids
        self.beacon_ids = beacons.map { $0.beaconId }
        
        
        for beacon in beacons {
            
            // check if beacon received from bluetooth is in the list of path items
            // If it is already stored, it means we found the display from bluetooth and should send path item
            for path_item_with_display in self.displayMemory {
                
                
                // check for second beacon ids and store if beacon is in range
                if path_item_with_display.second_beacon_id != nil {
                    
                    
                    // check if beacon is in range and is not already stored in secondBeaconIds array
                    if beacon_ids.contains(path_item_with_display.second_beacon_id!) && !self.secondBeaconIdsStore.contains(path_item_with_display.second_beacon_id!) {
                        self.secondBeaconIdsStore.append(path_item_with_display.second_beacon_id!)
                    }
                }
                
                // RESET alreadySent when beacon signal disappear
                alreadySent.removeAll(where: { !beacon_ids.contains($0.display_id) } )
                
                
                // if path has first_beacon_id (mean edge/path has display)
                // if this beacon is in range
                // if not already sent
                if path_item_with_display.first_beacon_id != nil
                    && path_item_with_display.first_beacon_id == beacon.beaconId
                    && !alreadySent.contains(where: { $0.destination_id == self.selectedDestination!.id && $0.display_id == path_item_with_display.first_beacon_id } ) {
                    do {
                        
                        // Check if display has a second beacon id.
                        // Second beacon id means the display is visible only when you arrived from the second beacon id position.
                        // And if this id has not already been stored, return.
                        // It means the application should have reach the second beacon first but did not.
                        if (path_item_with_display.second_beacon_id != nil && !self.secondBeaconIdsStore.contains(path_item_with_display.second_beacon_id!)) {
                            return
                        }
                        
                        // Store the item as already sent
                        self.alreadySent.append(PostSocket(destination_id: self.selectedDestination!.id, display_id: beacon.beaconId))
                        
                        
                        // Build the path item to send
                        let path_item: Path = buildPathItemToSend(path_item: path_item_with_display)
                        let path_item_to_send = try JSONEncoder().encode(path_item)
                        
                        
                        // Play sound and vibration
                        playSoundAndVibrate()
                        
                        
                        // Send path item to display using web socket
                        sendPathItemToDisplay(path_first_beacon_id: path_item.first_beacon_id!, path_item_to_send: path_item_to_send)
                        
                        
                        // Filter out the path item second beacon if stored
                        // The user needs to reach the second beacon again to be able to send the item.
                        if path_item.second_beacon_id != nil && self.secondBeaconIdsStore.contains(path_item.second_beacon_id!) {
                            let secondBeaconIdsStore = self.secondBeaconIdsStore.filter { $0 != path_item.second_beacon_id }
                            self.secondBeaconIdsStore = secondBeaconIdsStore
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        let position = setPosition(beacons: beacons)
        
        if(self.get_path_timer_count > 2) {
            self.getPath(position: position, beacons: beacons)
            self.get_path_timer_count = 0
        }
    }
    
    
    /**
     Build the path item to send to the socket server
     - parameter path_item: Path
     - returns: path_item
     */
    private func buildPathItemToSend(path_item: Path) -> Path {
        var path_item = path_item
        path_item.destination_id = self.selectedDestination!.id
        path_item.destination = self.selectedDestination
        return path_item
    }
    
    
    /**
     Emit the path item to the socket linked to the display (room id = path_item_with_display.first_beacon_id
     - parameter path_first_beacon_id : String
     - parameter path_item_to_send : Data
     */
    private func sendPathItemToDisplay(path_first_beacon_id: String, path_item_to_send: Data) {
        socket.emit("push_notification", ["roomId": path_first_beacon_id ,"json": path_item_to_send])
    }
    
    
    /**
     Get the current position of the device
     Send it throught delegate to debug screen to display the cursor
     - parameter beacons : [BCLBeacon]
     - returns: Estimate
     */
    private func setPosition(beacons: [BCLBeacon]) -> Estimate {
        let position: Estimate = EstimationService().locatePosition(beacons: beacons)
        pathPositionDelegate?.setCursorPosition( position: position)
        return position
    }
    
    
    /**
     Play sound and vibrate
     */
    private func playSoundAndVibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(1025))
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    
    /**
     Return the direction name to get the right vector image
     - parameter direction : String
     - returns: String
     */
    private func getArrow(direction: String) -> String {
        switch(direction) {
        case "straigt":
            return "direction_straight"
        case "back":
            return "direction_back"
        case "right":
            return "direction_right"
        case "left":
            return "direction_left"
        default:
            return "direction_straight"
        }
    }
    
    
    /**
     Get icon name from destination type id
     - parameter type : Int
     - returns: String
     */
    private func getIcon(type: Int) -> String {
        switch(type) {
        case 1:
            return "icon_toilet"
        case 2:
            return "icon_bus"
        case 3:
            return "icon_tower"
        case 4:
            return "icon_taxi"
        case 5:
            return "icon_train"
        case 6:
            return "icon_info"
        case 7:
            return "icon_locker"
        default:
            return "icon_bus"
        }
    }
    
    
    /**
     Get path from estimated position and list of beacons in range
     - parameter position: Estimate
     - parameter beacons: [BCLBeacon]
     */
    private func getPath(position: Estimate, beacons: [BCLBeacon]!) {
        
        let decimal_x = round(Double(truncating: position.x as NSNumber))
        let decimal_y = round(Double(truncating:position.y as NSNumber))
        
        let json: PostPath = PostPath(map_id: self.map!.id, x_pixel: decimal_x, y_pixel: decimal_y, destination_id: self.selectedDestination!.id)
        
        Api.shared.post(for: Path.self, path: "/getPath",  postData: json) {(res) in
            switch res {
            case.failure(let error):
                print(error)
            case .success(let data):
                DispatchQueue.main.async {
                    
                    // pathData is the actual list of paths
                    self.pathData = data
                    
                    // display memory will store only the paths which have a first_beacon_id meaning a display
                    self.displayMemory = []
                    
                    
                    for path in data {
                        // Store all beacon id from path
                        // Those beacon ids represent one display each
                        if(path.first_beacon_id != nil) {
                            self.displayMemory.append(path)
                        }
                    }
                    
                    // MARK: - handle the scroll effect at each table reload
                    
                    if(self.tableView.numberOfRows(inSection: 0) > 0 && self.tableView.numberOfRows(inSection: 0) == self.pathData.count) {
                        for (index, _) in data.enumerated() {
                            let indexPath = IndexPath(item: index, section: 0)
                            let contentOffset = self.tableView.contentOffset
                            self.tableView.beginUpdates()
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                            self.tableView.endUpdates()
                            self.tableView.layer.removeAllAnimations()
                            self.tableView.setContentOffset(contentOffset, animated: false)
                        }
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return pathData.count
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PathTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  as? PathTableViewCell else {
            fatalError("The dequeued cell is not an instance of PathTableViewCell.")
        }
        
        let path = pathData[indexPath.row]
        
        // path arrow depends on direction
        cell.arrowImage.image = UIImage(named: self.getArrow(direction: path.direction))
        // path icon depends on destination type
        cell.iconImage.image =  UIImage(named: self.getIcon(type: selectedDestination!.type_id))
        cell.labelTitle.text = self.destination_name
        cell.cellText.text = "\(path.distance)m \(NSLocalizedString(path.direction, tableName: current_table, comment: "path"))"
        cell.informationBoard.text = NSLocalizedString("Information board ID:", tableName: current_table, comment: "page-debug")
        
        return cell
    }
}
