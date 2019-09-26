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
    
    // destinations
    var destinations = [[Destination]]()
    var destinations_initial = [Destination]()
    var destinations_filtered = [[Destination]]()
    var destination_order_number = Int()
    // table
    var selectedCellLabel = String()
    // search
    var searchString = String()
    var searchActive : Bool = false
    var searchFocus : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    var language_current = Language.english
    
    var current_table = String();
    var selectedDestination: Destination? = nil
    
    //MARK: IBOutlet
    
    
    @IBOutlet weak var buttonLeftSettings: UIBarButtonItem!
    @IBOutlet weak var tableSearch: UISearchBar!
    @IBOutlet weak var navigation: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    
        
        //MARK: UI Setup
        
        navigation.title = NSLocalizedString("Destinations", tableName: self.getTableName(), comment: "navigation-title")
        tableSearch.delegate = self
        
        tableSearch.placeholder = NSLocalizedString("Enter a destination...", tableName: self.getTableName(), comment: "navigation-search");
        tableSearch.backgroundColor = UIColor.white
        
        for s in tableSearch.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.cornerRadius = 4.0
                s.layer.borderColor = UIColor(red:0.00, green:0.40, blue:0.69, alpha:1.0).cgColor
                
            }
        }
        
        
        //MARK: Load functions
        loadDestinations()
        
    }
    

    
    private func switchLanguage(language: String) {
        switch language {
        case "japanese":
            self.language_current = .japanese
        case "english":
            self.language_current = .english
        case "chinese":
            self.language_current = .chinese
        case "korean":
            self.language_current = .korean
        default:
            self.language_current = .japanese
        }
        navigation.title = NSLocalizedString("Destinations", tableName: self.getTableName(),comment: "navigation-title")
        tableSearch.placeholder = NSLocalizedString("Enter a destination...", tableName: self.getTableName(), comment: "navigation-search");
        
    }
    
    
    @IBAction func openLanguageAlert(_ sender: Any) {
        self.alertLanguage()
    }
    
    
    //MARK: private
    
    private func alertLanguage() {
        // set the alert controller
        let alert = UIAlertController(title:  NSLocalizedString("translation", tableName: "Main", comment: "alert"), message: "", preferredStyle: .alert)
        
        // set action for each language
        let japanese_action = UIAlertAction(title: "日本語", style: .default, handler: { (_) in
            self.switchLanguage(language: "japanese")
            
            self.tableView.reloadData()
        })
        
        let english_action = UIAlertAction(title: "English", style: .default, handler: { (_) in
            self.switchLanguage(language:"english")
            self.tableView.reloadData()
        })
        let chinese_action = UIAlertAction(title: "中文", style: .default, handler: { (_) in
            self.switchLanguage(language:"chinese")
            self.tableView.reloadData()
        })
        let korean_action = UIAlertAction(title: "한국어", style: .default, handler: { (_) in
            self.switchLanguage(language:"korean")
            self.tableView.reloadData()
        })
        
        // update default color to black
        japanese_action.setValue(UIColor.black, forKey: "titleTextColor")
        english_action.setValue(UIColor.black, forKey: "titleTextColor")
        chinese_action.setValue(UIColor.black, forKey: "titleTextColor")
        korean_action.setValue(UIColor.black, forKey: "titleTextColor")
        
        // add each action to the aler
        alert.addAction(japanese_action)
        
        alert.addAction(english_action)
        
        alert.addAction(chinese_action)
        
        alert.addAction(korean_action)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", tableName: "Main", comment: "global"), style: UIAlertAction.Style.cancel , handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        
        // show alert
        self.present(alert, animated: true, completion: nil)
        
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
        label.text = String(self.getCurrentLanguageTypeLabel(element: destinations[section][0]))
        label.textColor = UIColor.black // my custom colour
        headerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
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
        
        let text = self.getCurrentLanguageLabel(destination: destination)
        
        cell.destinationCellLabel.text = text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var label = String()
        _ = Int()
        
        if searchActive {
            label = self.getCurrentLanguageLabel(destination: destinations_filtered[indexPath.section][indexPath.row])
        } else {
            label = self.getCurrentLanguageLabel(destination: destinations[indexPath.section][indexPath.row])
        }
//        destination_order_number =
        print("Destination", destinations[indexPath.section][indexPath.row].id)
        self.selectedCellLabel = label
        self.selectedDestination = destinations[indexPath.section][indexPath.row] as Destination
        self.destination_order_number = destinations[indexPath.section][indexPath.row].order!
        
        self.alert(title: NSLocalizedString("Do you want to set the selected location as the destination?", tableName: self.getTableName(), comment: "alert"), message: label, completion: { result in
            if result {
                if self.selectedCellLabel != "" {
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
    
    //MARK: Alert
    
    
    func getTableName() -> String {
        switch language_current {
        case .english:
            self.current_table = "LocalizedEnglish"
            return "LocalizedEnglish"
        case .chinese:
            return "LocalizedChinese"
        case .korean:
            return "LocalizedKorean"
        default:
            self.current_table = "LocalizedJapanese"
            return "LocalizedJapanese"
        }
    }
    
    /**
     Display confirmation alert after clicking table cell
     - parameter title: string
     - parameter message: string
     - parameter completion: callback called with a boolean. boolean is used to trigger action in the callback
     */
    
    func alert (title: String, message: String, completion:  @escaping ((Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("start guidance", tableName: self.getTableName(), comment: "global"), style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion(true) // true signals "YES"
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", tableName: self.getTableName(), comment: "global"), style: UIAlertAction.Style.default, handler: { (action) in
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
        Api.shared.get(path: "/loadmap/6"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                
                // order destinations by id
                var destinations = map_data.destinations.sorted(by: { $0.id < $1.id }).enumerated().map { (arg) -> Destination in
                    
                    let (index, element) = arg
                    element.order = index + 1
                    return element
                }
                

                // give order number to destinations
                
                
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
        
        let dest = Dictionary(grouping: destinations) {(element) -> Int in
            return element.type_id
        }
        
        var destinations = [[Destination]]()
        
        for (_, value) in dest {
            destinations.append(value)
        }
        
        if searchActive {
            self.destinations_filtered = destinations
        } else {
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
    
    
 
    
    
    // MARK: - Search
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchFocus = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchFocus = false;
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
     - returns: [Destination] filtered by type_label or label
     */
    
    func searchFilter(searchText: String) -> [Destination] {
        return self.destinations_initial.filter({( destination : Destination) -> Bool in
            return self.getCurrentLanguageLabel(destination: destination).lowercased().contains(searchText.lowercased()) || self.getCurrentLanguageTypeLabel(element: destination).lowercased().contains(searchText.lowercased())
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
        if searchText.count == 0 {
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        if searchText.count > 0 && searchFocus {
            let filtered = self.searchFilter(searchText: searchText)
            return self.getTypes(destinations: filtered)
        } else {
            return self.getTypes(destinations: destinations_initial)
        }
    }
    
    /**
      Prepare the segue for the Icon Page
      - parameter segue: use to get the destination segue from this controller
      - parameter sender: Any
      */
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let iconController = segue.destination as! IconPageController
         iconController.destination_name = self.selectedCellLabel
         iconController.language_current = self.language_current
         iconController.current_table = self.current_table
         iconController.destination_order_number = self.destination_order_number
         iconController.selectedDestination = self.selectedDestination
     }
}


