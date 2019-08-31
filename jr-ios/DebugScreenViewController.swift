//
//  DebugScreenViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/31.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class DebugScreenViewController: UIViewController {

    @IBOutlet weak var NavLeftButton: UIBarButtonItem!
    @IBOutlet weak var NavRightButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavLeftButton.title = "戻る"
        if #available(iOS 13.0, *) {
            NavRightButton.image = UIImage(systemName: "exclamationmark.triangle.fill")
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{
                   owningNavigationController.popViewController(animated: true)
               } else {
                   fatalError("The Icon Page Controller is not inside a navigation controller.")
               }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
