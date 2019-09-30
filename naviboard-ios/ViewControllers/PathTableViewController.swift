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

protocol UpdatePathTable {
    func afterBeacon(beacons: [BCLBeacon]!, position: Estimate)
}

struct EmitData {
    var roomId: String
    var json: PathData
}

struct SocketObject {
    var destination_id: Int
    var display_id: String
}

class PathTableViewController: UITableViewController, BCLManagerDelegate {
    
    var delegate: UpdatePathTable?
    
    var paths = [Path]()
    var destination_name:String = String()
    var current_table = String()
    var pathData = [PathData]()
    var count = 0
    var pathMemory = [PathData]()
    var selectedDestination: Destination? = nil
    var alreadySent = [SocketObject]()
    var beacon_ids = [String]()
    //    @IBOutlet weak var informationBoard: UILabel!
    
    //MARK: Socker Manager
    let manager = SocketManager(socketURL: URL(string: "http://54.64.251.38:8080")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Beacrew Manager
        BCLManager.shared()?.delegate = self
    }
    
    func getPath(position: Estimate, beacons: [BCLBeacon]!) {
        // prepare json data
        let json: PostData = PostData(map_id: 6, node_start_id: 1, node_end_id: 5)
        
        Api.shared.post( path: "/getPath",  myData: json) {(res) in
            switch res {
            case.failure(let error):
                print(error)
            case .success(let data):
                DispatchQueue.main.async {
                    self.pathData = data
                    self.pathMemory = []
                    for path in data {
                        // store all beacon id from path - Those beacon ids represent one display each
                        if(path.beacon_id != nil) {
                            self.pathMemory.append(path)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: Socket
    
    func checkAliveSocket() {
        socket = manager.defaultSocket
        if(socket!.status==SocketIOStatus.notConnected){
            socket.on(clientEvent: .connect) {data, ack in
                self.socket.emit("chat_message", "connected")
            }
            socket.connect()
        }
    }
    
    func didRangeBeacons(_ beacons: [BCLBeacon]!) {
        //        self.count += 1
        
        self.checkAliveSocket()
        
        self.beacon_ids = beacons.map { $0.beaconId }
        
        for beacon in beacons {
            for path_item in self.pathMemory {
                // check if beacon received from bluetooth is in the list of path items
                // if exists - it means we found the display from bluetooth and should send path item
                
                // RESET alreadySent when beacon signal disappear
                alreadySent.removeAll(where: { !beacon_ids.contains($0.display_id) } )
                
                if path_item.beacon_id != nil
                    && path_item.beacon_id == beacon.beaconId
                    && !alreadySent.contains(where: { $0.destination_id == self.selectedDestination!.id && $0.display_id == beacon.beaconId } ) {
                    do {
                        var path_item = path_item
                        path_item.destination_id = self.selectedDestination!.id
                        path_item.destination = self.selectedDestination
                        
                        let path_item_to_send = try JSONEncoder().encode(path_item)
                        
                        self.alreadySent.append(SocketObject(destination_id: self.selectedDestination!.id, display_id: beacon.beaconId))
                        socket.emit("push_notification", ["roomId": beacon.beaconId! ,"json": path_item_to_send])
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        let position: Estimate = EstimationService().locatePosition(beacons: beacons)
        print("POSITION", position)
        delegate?.afterBeacon(beacons: beacons, position: position)
        //        if(count == 3) {
        self.getPath(position: position, beacons: beacons)
        //            self.count = 0
        //        }
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
        
        // Configure the cell...
        
        let path = pathData[indexPath.row]
        
        // path arrow depends on direction
        cell.arrowImage.image = UIImage(named: self.getArrow(direction: path.direction))
        // path icon depends on destination type
        cell.iconImage.image =  UIImage(named: self.getIcon(type: selectedDestination!.type_id))
        cell.labelTitle.text = self.destination_name
        cell.cellText.text = "\(50)m\(NSLocalizedString(path.direction, tableName: current_table, comment: "path"))"
        cell.informationBoard.text = NSLocalizedString("Information board ID:", tableName: current_table, comment: "page-debug")
        
        return cell
    }
    
    func getIcon(type: Int) -> String {
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
    
    // MARK: Private functions
    
    func getArrow(direction: String) -> String {
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
