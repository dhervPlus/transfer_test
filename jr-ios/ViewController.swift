//
//  ViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/23.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var destinations = [Destination]()
    var searchString: String = String()
    
    
    
    @IBOutlet weak var buttonLeftSettings: UIBarButtonItem!
    @IBOutlet weak var buttonRightSettings: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            buttonRightSettings.image = UIImage(systemName: "gear")
            buttonLeftSettings.image = UIImage(systemName: "a.square")
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    
    //
    //    func searchBarIsEmpty() -> Bool {
    //        // Returns true if the text is empty or nil
    //        return searchController.searchBar.text?.isEmpty ?? true
    //    }
    
    //    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    //        print(searchText)
    //        self.searchString = searchText.lowercased()
    //        let vc = DestinationTableViewController()
    //        vc.filterContentForSearchText(searchText.lowercased())
    //
    //        //      filteredCandies = candies.filter({( candy : Candy) -> Bool in
    ////        return candy.name.lowercased().contains(searchText.lowercased())
    ////      })
    ////
    ////      tableView.reloadData()
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationTableController = segue.destination as! DestinationTableViewController
        destinationTableController.searchString = self.searchString
    }
    
    
    
}


