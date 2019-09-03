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
    @IBOutlet weak var TextLabel: UILabel!
    
    
    @IBOutlet weak var ImageWarningLeft: UIImageView!
    @IBOutlet weak var ImageWarningRight: UIImageView!
    
    var myString:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.mainImageView.layer.masksToBounds = true
        NavLeftItem.title = "戻る"
        TextLabel.text = "目的地：\(myString)"
        
        
        
        if #available(iOS 13.0, *) {
            ImageWarningLeft.image = UIImage(systemName: "exclamationmark.triangle.fill")
            ImageWarningRight.image = UIImage(systemName: "exclamationmark.triangle.fill")
            
            NavRightItem.image = UIImage(systemName: "gear")
            
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
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
    }
    
    
    
    
}
