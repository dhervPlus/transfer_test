//
//  PathTableViewController.swift
//  jr-ios
//
//  Created by damien on 2019/09/02.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class PathTableViewController: UITableViewController {
    
    var paths = [Path]()
    var myString:String = String()
    var current_table = String()

//    @IBOutlet weak var informationBoard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       
        
        loadSamplePaths()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paths.count
    }

    private func loadSamplePaths() {
        
        let bg = UIImage(named: "JR-icon3.png")
        let icon = UIImage(named: "Group 17.3bus")
        let arrow = UIImage(named: "Vector")
        
        guard let path1 = Path(id: 1, icon: icon!, arrow: arrow!, bg: bg!) else {
            fatalError("Unable to instantiate path1")
        }
        
        guard let path2 = Path(id: 2, icon: icon!, arrow: arrow!, bg: bg!) else {
            fatalError("Unable to instantiate path2")
        }
        
        guard let path3 = Path(id: 3, icon: icon!, arrow: arrow!, bg: bg!) else {
            fatalError("Unable to instantiate path3")
        }
        
        paths += [path1, path2, path3]
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
        
        let path = paths[indexPath.row]
        
        cell.bgImage.image = path.bg
        cell.arrowImage.image = path.arrow
        cell.iconImage.image = path.icon
        cell.labelTitle.text = self.myString
        cell.cellText.text = "50m先階段を降りて左に曲がる。"
        cell.informationBoard.text = NSLocalizedString("Information board ID:", tableName: current_table, comment: "page-debug")

        return cell
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
