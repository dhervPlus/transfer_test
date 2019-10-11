//
//  DestinationTableViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit
import BeacrewLoco


class DestinationTableViewController: UITableViewController, UISearchBarDelegate, BCLManagerDelegate {
    
    //MARK: Variables
    
    var destinations = [[Destination]]()
    var destinations_initial = [Destination]()
    var destinations_filtered = [[Destination]]()
    var language_current = Language.english
    var loaded = false
    var selected_destination: Destination? = nil
    var selected_destination_name = String()
    var selected_destination_order = Int()
    var searchFocus : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: IBOutlet
    @IBOutlet weak var tableSearch: UISearchBar!
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set language table globally
        Globals.current_language_table = language_current.rawValue
        
        //MARK: UI Setup
        
        navigation.title = NSLocalizedString("Destinations", tableName: Globals.current_language_table, comment: "navigation-title")
        tableSearch.delegate = self
        
        tableSearch.placeholder = NSLocalizedString("Enter a destination...", tableName: Globals.current_language_table, comment: "navigation-search");
        tableSearch.backgroundColor = UIColor.white
        
        // Loader
        self.view.showActivityIndicatory()
        
        // Search
        for textfield in tableSearch.subviews[0].subviews {
            if textfield is UITextField {
                let color = UIColor(red:0.00, green:0.40, blue:0.69, alpha:1.0).cgColor
                textfield.addBorder(width: 1.0, cornerRadius: 4.0, color: color)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: Beacrew Manager
        BCLManager.shared()?.delegate = self
        
    }
    
    // MARK: BCL functions
    
    func didRangeBeacons(_ beacons: [BCLBeacon]!) {
        let first_beacon_id = beacons.first?.beaconId
        if(!self.loaded) {
            self.loadDestinations(beacon_id: first_beacon_id!)
        }
    }
    
    // MARK: Alert
    
    /**
     Open language alert on navigation button click
     */
    @IBAction func openLanguageAlert(_ sender: UIBarButtonItem) {
        self.alertLanguage()
    }
    
    /**
     Display confirmation alert after clicking table cell
     - parameter title: string
     - parameter message: string
     - parameter completion: callback called with a boolean. boolean is used to trigger action in the callback
     */
    
    private func alert (title: String, message: String, completion:  @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("start guidance", tableName: Globals.current_language_table, comment: "global"), style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(true) // true signals "YES"
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", tableName: Globals.current_language_table, comment: "global"), style: UIAlertAction.Style.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(false) // false singals "NO"
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /**
     Display alert language selection
     */
    private func alertLanguage() {
        let alert = UIAlertController(title:  NSLocalizedString("translation", tableName: "Main", comment: "alert"), message: "", preferredStyle: .alert)
        self.alertAddButtonsActions(alert: alert)
    }
    
    /**
     Add actions to each one of the language alert button
     - parameter alert: UIAlertController
     */
    private func alertAddButtonsActions(alert: UIAlertController) {
        let japanese_action = UIAlertAction(title: "日本語", style: .default, handler: { (_) in
            self.language_current = .japanese
            Globals.current_language_table = Language.japanese.rawValue
            self.updateLanguageView()
        })
        let english_action = UIAlertAction(title: "English", style: .default, handler: { (_) in
            self.language_current = .english
            Globals.current_language_table = Language.english.rawValue
            self.updateLanguageView()
        })
        let chinese_action = UIAlertAction(title: "中文", style: .default, handler: { (_) in
            self.language_current = .chinese
            Globals.current_language_table = Language.chinese.rawValue
            self.updateLanguageView()
        })
        let korean_action = UIAlertAction(title: "한국어", style: .default, handler: { (_) in
            self.language_current = .korean
            Globals.current_language_table = Language.korean.rawValue
            self.updateLanguageView()
        })
        
        // Update default color to black
        japanese_action.setValue(UIColor.black, forKey: "titleTextColor")
        english_action.setValue(UIColor.black, forKey: "titleTextColor")
        chinese_action.setValue(UIColor.black, forKey: "titleTextColor")
        korean_action.setValue(UIColor.black, forKey: "titleTextColor")
        
        // Add each action to the aler
        alert.addAction(japanese_action)
        alert.addAction(english_action)
        alert.addAction(chinese_action)
        alert.addAction(korean_action)
        
        // Add cancel action
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", tableName: "Main", comment: "global"), style: UIAlertAction.Style.cancel , handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /**
     Update the view with new selected language
     */
    private func updateLanguageView() {
        navigation.title = NSLocalizedString("Destinations", tableName: Globals.current_language_table,comment: "navigation-title")
        tableSearch.placeholder = NSLocalizedString("Enter a destination...", tableName: Globals.current_language_table, comment: "navigation-search");
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return destinations.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: sectionView.frame.width, height: sectionView.frame.height)
        label.text = String(self.getCurrentLanguageTypeLabel(element: destinations[section][0]))
        label.textColor = UIColor.black // my custom colour
        
        
        sectionView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        sectionView.addSubview(label)
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var destination: Destination
        let cellIdentifier = "DestinationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DestinationTableViewCell else {
            fatalError("The dequeued cell is not an instance of DestinationTableViewCell.")
        }
        
        destination = destinations[indexPath.section][indexPath.row]
        
        let text = self.getCurrentLanguageLabel(destination: destination)
        
        cell.destinationCellLabel.text = text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var label = String()
        _ = Int()
        
        label = self.getCurrentLanguageLabel(destination: destinations[indexPath.section][indexPath.row])
        
        self.selected_destination_name = label
        self.selected_destination = destinations[indexPath.section][indexPath.row] as Destination
        self.selected_destination_order = destinations[indexPath.section][indexPath.row].order!
        
        self.alert(title: NSLocalizedString("Do you want to set the selected location as the destination?", tableName: Globals.current_language_table, comment: "alert"), message: label, completion: { result in
            if result {
                if self.selected_destination_name != "" {
                    self.performSegue(withIdentifier: "Segue", sender: self)
                }
            }
        })
    }
    
    
    private func getCurrentLanguageTypeLabel(element: Destination) -> String {
        switch language_current {
        case .english:
            return element.type_label_english
        case .chinese:
            return element.type_label_chinese
        case .korean:
            return element.type_label_korean
        default:
            return element.type_label_japanese
        }
    }
    
    private func getCurrentLanguageLabel(destination: Destination) -> String {
        switch language_current {
        case .english:
            return destination.label_english
        case .chinese:
            return destination.label_chinese
        case .korean:
            return destination.label_korean
        default:
            return destination.label_japanese
        }
    }
    
    
    //MARK: Load Destinations
    
    /**
     Api call to get the destinations from the current map
     - returns: call to getTypes()
     */
    
    private func loadDestinations(beacon_id: String) {
        
        Api.shared.get(for: MapData.self, path: "/map/current/\(beacon_id)"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                // order destinations by id
                _ = map_data.destinations.sorted(by: { $0.id < $1.id }).enumerated().map { (arg) -> Destination in
                    
                    var (index, element) = arg
                    element.order = index + 1
                    return element
                }
                // give order number to destinations
                self.destinations_initial = map_data.destinations
                self.loaded = true
                
                return self.getTypes(destinations: map_data.destinations)
            }
        }
        self.view.stopActivityIndicator()
    }
    
    
    /**
     Map destinations array to a two-dimensional array grouped by types
     - parameter destinations: Array of Destination
     - returns: tableView.reloadData()
     */
    
    private func getTypes(destinations: [Destination]) {
        
        let dest = Dictionary(grouping: destinations) {(element) -> Int in
            return element.type_id
        }
        
        var destinations = [[Destination]]()
        
        for (_, value) in dest {
            destinations.append(value)
        }
        
        // Always sort destinations in the same order
        destinations = destinations.sorted(by: {$0.first!.type_label_english < $1.first!.type_label_english})
        
        self.destinations = destinations
        
        DispatchQueue.main.async {
            return self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Search
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchFocus = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchFocus = false;
    }
    
    /**
     Filter destinations depending on the current search text in the search bar
     - parameter searchText: string in search bar
     - returns: [Destination] filtered by type_label or label
     */
    
    func searchFilter(searchText: String) -> [Destination] {
        return self.destinations_initial.filter({( destination : Destination) -> Bool in
            return self.getCurrentLanguageLabel(destination: destination).lowercased().contains(searchText.lowercased()) || self.getCurrentLanguageTypeLabel(element: destination).lowercased().contains(searchText.lowercased())
        })
    }
    
    /**
     Called when user is typing in the search bar.
     - parameter searchBar: UISearchBar
     - parameter searchText: String
     - returns: call getTypes with the initial destination array or the filtered one if search is active
     */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchActive = searchText.count > 0
        if searchFocus && searchActive {
            let filtered = self.searchFilter(searchText: searchText)
            return self.getTypes(destinations: filtered)
        } else {
            return self.getTypes(destinations: destinations_initial)
        }
    }
    
    
    // MARK: Segue
    
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
     Prepare the segue for the Icon Page
     - parameter segue: use to get the destination segue from this controller
     - parameter sender: Any
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let iconController = segue.destination as! IconPageController
        iconController.selected_destination_name = self.selected_destination_name
        iconController.selected_destination_order = self.selected_destination_order
        iconController.selected_destination = self.selected_destination
    }
}


