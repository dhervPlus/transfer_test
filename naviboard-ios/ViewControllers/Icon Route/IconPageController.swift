//
//  IconPageController.swift
//  naviboard-ios
//
//  Created by damien on 2019/08/30.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class IconPageController: UIViewController {
    
    @IBOutlet weak var NavRightItem: UIBarButtonItem!
    @IBOutlet weak var NavLeftItem: UIBarButtonItem!
    
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var dangerMessage: UILabel!
    
    
    
    @IBOutlet weak var imageContainer: UIView!
    
    var current_language_table = Globals.current_language_table
    var selected_destination: Destination? = nil
    var selected_destination_name = String()
    var selected_destination_order = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAV
        navigation.title = NSLocalizedString("Routes", tableName: current_language_table, comment: "navigation-title")
        NavLeftItem.title = NSLocalizedString("Back", tableName: current_language_table, comment: "navigation-item")
        
        // PAGE
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let myMutableString = NSMutableAttributedString(
            string: "\(NSLocalizedString("Destination:", tableName: current_language_table, comment: "global")) \(selected_destination_name)",
            attributes: attributes)
        
        
        subtitle.attributedText = myMutableString
        subtitle.layer.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        imageContainer.layer.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0).cgColor
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.borderColor = UIColor(red:0.77, green:0.77, blue:0.77, alpha:1.0).cgColor
        imageContainer.layer.cornerRadius = 4
        
        firstParagraph.text = NSLocalizedString("This icon is displayed on the information board. Please walk along the arrow with this icon during guidance.", tableName: current_language_table, comment: "page-route")
        secondParagraph.text = NSLocalizedString("As you approach the next guide, you will be notified by sound and vibration.",  tableName: current_language_table, comment: "page-route")
        dangerMessage.text = NSLocalizedString("Walking with a smartphone is dangerous!", tableName: current_language_table, comment: "page-route")
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if selected_destination_order > 0 && selected_destination_order < 12 {
            let image_name = "destination_\(String(describing: selected_destination_order))"
            let image = UIImage(named: image_name)
            mainImageView.image = image
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let debugScreenController = segue.destination as! DebugScreenViewController
        debugScreenController.selected_destination = self.selected_destination
            debugScreenController.selected_destination_name = self.selected_destination_name
           
        
    }
    
    
    
    
}
