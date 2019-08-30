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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavLeftItem.title = "戻る"
        
        if #available(iOS 13.0, *) {
            NavRightItem.image = UIImage(systemName: "gear")
                 
               } else {
                   // Fallback on earlier versions
               }

        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation

     
    @IBAction func CancelAction(_ sender: UIBarButtonItem) {
               self.navigationController?.popViewController(animated: true)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
