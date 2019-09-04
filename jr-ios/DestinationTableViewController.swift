//
//  DestinationTableViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class DestinationTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Variables
    
    // destinations
    var destinations = [[Destination]]()
    var destinations_initial = [Destination]()
    var destinations_filtered = [[Destination]]()
    // table
    var sections: [String] = []
    var selectedCellLabel = String()
    // search
    var searchString = String()
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: IBOutlet
    @IBOutlet weak var buttonLeftSettings: UIBarButtonItem!
    @IBOutlet weak var buttonRightSettings: UIBarButtonItem!
    @IBOutlet weak var tableSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSearch.delegate = self
        
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            buttonRightSettings.image = UIImage(systemName: "gear")
            buttonLeftSettings.image = UIImage(systemName: "a.square")
        } else {
            // Fallback on earlier versions
        }
        
        // Load functions
        loadDestinations()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive {
            return destinations_filtered.count
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
        if searchActive {
            return destinations_filtered[section].count
        }
        return destinations[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var destination: Destination
        let cellIdentifier = "DestinationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DestinationTableViewCell else {
            fatalError("The dequeued cell is not an instance of DestinationTableViewCell.")
        }
        
        if searchActive {
            destination = destinations_filtered[indexPath.section][indexPath.row]
        } else {
            destination = destinations[indexPath.section][indexPath.row]
        }
        
        cell.destinationCellLabel.text = destination.label_japanese
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var label = String()
        
        if searchActive {
            label = destinations_filtered[indexPath.section][indexPath.row].label_japanese
        } else {
            label = destinations[indexPath.section][indexPath.row].label_japanese
        }
        
        self.selectedCellLabel = label
        
        self.alert(title: "選択した場所を目的地に設定しますか？", message: label, completion: { result in
            if result {
                if self.selectedCellLabel != "" {
                    self.performSegue(withIdentifier: "Segue", sender: self)
                }
            }
        })
    }
    
    
    //MARK: Alert
    
    
    /**
     Display confirmation alert after clicking table cell
     - parameter title: string
     - parameter message: string
     - parameter completion: callback called with a boolean. boolean is used to trigger action in the callback
     */
    
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
    
    //MARK: Load Destinations
    
    
    /**
     Api call to get the destinations from the current map
     - returns: call to getTypes()
     */
    
    private func loadDestinations() {
        Api.shared.get(path: "/loadmap/16"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                self.destinations_initial = map_data.destinations
                return self.getTypes(destinations: map_data.destinations)
            }
        }
    }
    
    
    /**
     Map destinations array to a two-dimensional array grouped by types
     - parameter destinations: Array of Destination
     - returns: tableView.reloadData()
     */
    
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
            self.sections = sections
            self.destinations_filtered = destinations
        } else {
            self.sections = sections
            self.destinations = destinations
        }
        
        DispatchQueue.main.async {
            return self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Segue Icon Controller
    
    
    /**
     Prevent segue to happen automatically. Use to show confirmation alert
     - parameter identifier: segue identifier
     - returns: Boolean
     */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Segue" {
            return false
        }
        return true
    }
    
    
    /**
     Set current selected row title. WIll be passed to Icon Controller
     - parameter label: title of selected row
     */
    
    private func openIconPage(label: String) {
        self.selectedCellLabel = label
    }
    
    
    /**
     Prepare the segue for the Icon Page
     - parameter segue: use to get the destination segue from this controller
     - parameter sender: Any
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let iconController = segue.destination as! IconPageController
        iconController.myString = self.selectedCellLabel
    }
    
    
    // MARK: - Search
    
    
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
    
    
    /**
     Filter destinations depending on the current search text in the search bar
     - parameter searchText: string in search bar
     - returns: [Destination]
     */
    
    func searchFilter(searchText: String) -> [Destination] {
        return self.destinations_initial.filter({( destination : Destination) -> Bool in
            return destination.label_japanese.lowercased().contains(searchText.lowercased())
        })
    }
    
    
    /**
     Called when user is typing in the search bar.
     Will set searchActive depending on the searchText parameter string  is empty or not
     - parameter searchBar: UISearchBar tableSearch
     - parameter searchText: string in the search bar
     - returns:
     getTypes(destinations)  with fitered destination if searchActive = true (searchText.count > 0) or with destinations_initial  if searchActive = false (searchText.count == 0)
     */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filtered = self.searchFilter(searchText: searchText)
        
        if searchText.count == 0 {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        if searchActive {
            return self.getTypes(destinations: filtered)
        } else {
            return self.getTypes(destinations: destinations_initial)
        }
    }
    
}


