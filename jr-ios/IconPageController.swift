//
//  IconPageController.swift
//  jr-ios
//
//  Created by damien on 2019/08/30.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class IconPageController: UIViewController {
    
    @IBOutlet weak var NavRightItem: UIBarButtonItem!
    @IBOutlet weak var NavLeftItem: UIBarButtonItem!
    
    @IBOutlet weak var mainImageView: UIImageView!
        
    
    @IBOutlet weak var ImageWarningLeft: UIImageView!
    @IBOutlet weak var ImageWarningRight: UIImageView!
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var dangerMessage: UILabel!
    
    
    var language_current = Language.english
    var current_table = String()
    var myString:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAV
        navigation.title = NSLocalizedString("Routes", tableName: self.getTableName(), comment: "navigation-title")
        NavLeftItem.title = NSLocalizedString("Back", tableName: self.getTableName(), comment: "navigation-item")
        
        // PAGE
        subtitle.text = "\(NSLocalizedString("Destination:", tableName: self.getTableName(), comment: "global")) \(myString)"
        
        firstParagraph.text = NSLocalizedString("This icon is displayed on the information board. Please walk along the arrow with this icon during guidance.", tableName: self.getTableName(), comment: "page-route")
        secondParagraph.text = NSLocalizedString("As you approach the next guide, you will be notified by sound and vibration.",  tableName: self.getTableName(), comment: "page-route")
        dangerMessage.text = NSLocalizedString("Walking with a smartphone is dangerous!", tableName: self.getTableName(), comment: "page-route")
        
        
        // ICONS
        if #available(iOS 13.0, *) {
            ImageWarningLeft.image = UIImage(systemName: "exclamationmark.triangle.fill")
            ImageWarningRight.image = UIImage(systemName: "exclamationmark.triangle.fill")
            
            NavRightItem.image = UIImage(systemName: "gear")
            
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getTableName() -> String {
        switch language_current {
           case .english:
               return "LocalizedEnglish"
           case .chinese:
               return "LocalizedChinese"
           case .korean:
               return "LocalizedKorean"
           default:
               return "LocalizedJapanese"
           }
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The Icon Page Controller is not inside a navigation controller.")
        }
    }
    
    //    @IBAction func CancelAction(_ sender: UIBarButtonItem) {
    //         dismiss(animated: true, completion: nil)
    ////               self.navigationController?.popViewController(animated: true)
    //    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.myString)
        let debugScreenController = segue.destination as! DebugScreenViewController
        debugScreenController.myString = self.myString
        debugScreenController.current_table = self.current_table
    }
    
    
    
    
}
