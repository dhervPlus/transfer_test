//
//  DestinationTableViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class DestinationTableViewController: UITableViewController {
    
    //MARK: Properties
    var destinations = [[Destination]]()
    var sections: [String] = []
    
    //    var completionHandler:(([Destination]) -> ())?
    
    
    
    //    func setDestinations(destinations: [Destination]){
    //        print("reload", destinations)
    //        self.destinations = destinations
    //        print("reload", self.destinations)
    //
    //        DispatchQueue.main.async{
    //            self.tableView.reloadData()
    //        }
    //
    //
    //
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Load the sample data.
        
        loadDestinations()
        
    }
    
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return destinations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = String(sections[section])
        label.textColor = UIColor.black // my custom colour
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = UIColor.systemGray5
        } else {
            // Fallback on earlier versions
        }
        headerView.addSubview(label)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     
        return destinations[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DestinationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DestinationTableViewCell else {
            fatalError("The dequeued cell is not an instance of DestinationTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        
        let destination = destinations[indexPath.section][indexPath.row]
        
        
        cell.destinationCellLabel.text = destination.label_japanese
        
        //         Configure the cell...
        
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
    
    
    //MARK: Events
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("section: \(indexPath.section)")
        print("row: \(destinations[indexPath.section][indexPath.row].label_japanese)")
        // OPEN ALERT
        
        let label = destinations[indexPath.section][indexPath.row].label_japanese
        let alert = UIAlertController(title: "選択した場所を目的地に設定しますか？", message: label, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: { _ in
            return
        }))
        alert.addAction(UIAlertAction(title: "案内を開始",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        self.openIconPage()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    
    private func loadDestinations() {
        Api.shared.get(path: "/loadmap/16"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                self.getTypes(destinations: map_data.destinations)
            }
        }
        
    }
    
    private func getTypes(destinations: [Destination]) {
      
        let dest = Dictionary(grouping: destinations) {(element) -> String in
            return element.type_label
        }
        
        for (key, value) in dest {
            self.sections.append(key)
            self.destinations.append(value)
        }
 
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func openIconPage() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "IconPageController") as? IconPageController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
