//
//  ViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/23.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    


}

