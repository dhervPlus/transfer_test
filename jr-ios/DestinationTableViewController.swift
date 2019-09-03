//
//  DestinationTableViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class DestinationTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    var destinations = [[Destination]]()
    var unordered_destinations = [Destination]()
    var filterd_destinations = [[Destination]]()
    var sections: [String] = []
    var thisString = String()
    var searchString = String()
    
    var searchActive : Bool = false
    
    @IBOutlet weak var searchBarTest: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    
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
    @IBOutlet weak var buttonLeftSettings: UIBarButtonItem!
    
    @IBOutlet weak var buttonRightSettings: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        //        searchController.searchResultsUpdater = self
        //        searchController.obscuresBackgroundDuringPresentation = false
        //        searchController.searchBar.placeholder = "Search..."
        //        searchController.searchBar = searchBarTest
        //        definesPresentationContext = false
        
        searchBarTest.delegate = self
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            buttonRightSettings.image = UIImage(systemName: "gear")
            buttonLeftSettings.image = UIImage(systemName: "a.square")
        } else {
            // Fallback on earlier versions
        }
        loadDestinations()
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchActive {
            return filterd_destinations.count
        }
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
        if searchActive {
            print(section, filterd_destinations)
            
            return filterd_destinations[section].count
        }
        return destinations[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DestinationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DestinationTableViewCell else {
            fatalError("The dequeued cell is not an instance of DestinationTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        
        var destination: Destination
        
        
        if searchActive {
            destination = filterd_destinations[indexPath.section][indexPath.row]
        } else {
            destination = destinations[indexPath.section][indexPath.row]
        }
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Segue" {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var label = String()
        // OPEN ALERT
        if searchActive {
            label = filterd_destinations[indexPath.section][indexPath.row].label_japanese
        } else {
            label = destinations[indexPath.section][indexPath.row].label_japanese
        }
        
        self.thisString = label
        
        self.alert(title: "選択した場所を目的地に設定しますか？", message: label, completion: { result in
            if result {
                if self.thisString != "" {
                    self.performSegue(withIdentifier: "Segue", sender: self)
                }
            }
        })
    }
    
    
    
    func alert (title: String, message: String, completion:  @escaping ((Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "案内を開始", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(true) // true signals "YES"
        }))
        
        alertController.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(false) // false singals "NO"
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    
    private func loadDestinations() {
        Api.shared.get(path: "/loadmap/16"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                self.unordered_destinations = map_data.destinations
                
                self.getTypes(destinations: map_data.destinations)
            }
        }
        
        
    }
    
    private func getTypes(destinations: [Destination]) {
        
        let dest = Dictionary(grouping: destinations) {(element) -> String in
            return element.type_label
        }
        
        var sections: [String] = []
        var destinations = [[Destination]]()
        
        for (key, value) in dest {
            sections.append(key)
            destinations.append(value)
        }
        if searchActive {
            print("SECTION", destinations)
            self.sections = sections
            self.filterd_destinations = destinations
        } else {
            self.sections = sections
            self.destinations = destinations
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func openIconPage(label: String) {
        self.thisString = label
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let iconController = segue.destination as! IconPageController
        iconController.myString = self.thisString
    }
    
    // MARK: - Private instance methods
    
    func isFiltering() -> Bool {
        
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("SEARCH", searchText)
        let filtered = self.unordered_destinations.filter({( destination : Destination) -> Bool in
            
            return destination.label_japanese.lowercased().contains(searchText.lowercased())
        })
        
        if searchText.count == 0 {
            print("fdsaf")
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        if searchText.count > 0  {
            print("HERE")
            self.getTypes(destinations: filtered)
        }
        
        if searchText.count ==  0 {
            self.getTypes(destinations: unordered_destinations)
        }
    }
    
    //    func filterContentForSearchText(_searchBar: UISearchBar, textDidChange searchText: String) {
    //
    //        print("SEARCH", searchText)
    //        let filtered = self.unordered_destinations.filter({( destination : Destination) -> Bool in
    //
    //            return destination.label_japanese.lowercased().contains(searchText.lowercased())
    //        })
    //
    //        if isFiltering() {
    //            self.getTypes(destinations: filtered)
    //        }
    //
    //        if searchBarIsEmpty() {
    //            self.getTypes(destinations: unordered_destinations)
    //        }
    //
    //
    //    }
    
    
}

//extension DestinationTableViewController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        // TODO
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
//}

