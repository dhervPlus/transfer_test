//
//  PathTableViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/02.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit
import BeacrewLoco

protocol UpdatePathTable {
    func afterBeacon(beacons: [BCLBeacon]!, position: Estimate)
}

class PathTableViewController: UITableViewController, BCLManagerDelegate {
    
    var delegate: UpdatePathTable?
    
    var paths = [Path]()
    var myString:String = String()
    var current_table = String()
    var pathData = [PathData]()
    var count = 0
    //    @IBOutlet weak var informationBoard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        
        //        loadSamplePaths()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Beacrew Manager
        BCLManager.shared()?.delegate = self
    }
    //    func setData(data: [PathData]) {
    //         print("PATH", data)
    //          DispatchQueue.main.async {
    //        self.pathData = data
    //
    //                 self.tableView.reloadData()
    //        }
    //
    //    }
    
    func getPath(position: Estimate) {
        // prepare json data
        let json: PostData = PostData(map_id: 6, node_start_id: 1, node_end_id: 5)
        
        print("CALLED")
        Api.shared.post( path: "/getPath",  myData: json) {(res) in
            switch res {
            case.failure(let error):
                print(error)
            case .success(let data):
                DispatchQueue.main.async {
                    self.pathData = data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func didRangeBeacons(_ beacons: [BCLBeacon]!) {
        self.count += 1
        
        let position: Estimate = EstimationService().locatePosition(beacons: beacons)
        delegate?.afterBeacon(beacons: beacons, position: position)
        
        if(count == 3) {
            
            
            self.getPath(position: position)
            self.count = 0
        }
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("COUNT", pathData.count)
        return pathData.count
    }
    
    //    private func loadSamplePaths() {
    //
    //        //        let bg = UIImage(named: "JR-icon3.png")
    //        let icon = UIImage(named: "Group 17.3bus")
    //        let arrow = UIImage(named: "Vector")
    //
    //        guard let path1 = Path(id: 1, icon: icon!, arrow: arrow!) else {
    //            fatalError("Unable to instantiate path1")
    //        }
    //
    //        guard let path2 = Path(id: 2, icon: icon!, arrow: arrow!) else {
    //            fatalError("Unable to instantiate path2")
    //        }
    //
    //        guard let path3 = Path(id: 3, icon: icon!, arrow: arrow!) else {
    //            fatalError("Unable to instantiate path3")
    //        }
    //
    //        paths += [path1, path2, path3]
    //    }
    
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
        print("CELLL", path)
        // path arrow depends on direction
        cell.arrowImage.image = UIImage(named: self.getArrow(direction: path.direction))
        // path icon depends on destination type
        cell.iconImage.image =  UIImage(named: "Group 17.3bus")
        cell.labelTitle.text = self.myString
        cell.cellText.text = "\(50)m\(NSLocalizedString(path.direction, tableName: current_table, comment: "path"))"
        cell.informationBoard.text = NSLocalizedString("Information board ID:", tableName: current_table, comment: "page-debug")
        
        return cell
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
