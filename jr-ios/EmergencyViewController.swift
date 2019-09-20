//
//  EmergencyViewController.swift
//  jr-ios
//
//  Created by damien on 2019/09/09.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var circleContainer: UIButton!
    @IBOutlet weak var emergencyTitle: UILabel!
    @IBOutlet weak var emergencyText: UILabel!
    
    var current_table = String();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawCircle()
        
        emergencyTitle.text = NSLocalizedString("Emergency guide settings", tableName: current_table, comment: "emergency")
        emergencyText.text = NSLocalizedString("Press the button to switch the screen to emergency mode.", tableName: current_table, comment: "emergency")
        // Do any additional setup after loading the view.
    }
    
    private func drawCircle() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 120, y: 120), radius: CGFloat(80), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.red.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.white.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 6.0
        
        circleContainer.backgroundColor = UIColor.clear
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 10
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 2
        
        circleContainer.layer.addSublayer(shapeLayer)
        
        //       emergencyButton.backgroundColor = .clear
        //        emergencyButton.layer.cornerRadius = 0.5 * emergencyButton.bounds.size.width
        //        emergencyButton.clipsToBounds = true
        //        emergencyButton.layer.borderWidth = 5
        //        emergencyButton.layer.borderColor = UIColor.white.cgColor
        ////        emergencyButton.backgroundColor = UIColor.red
        //        emergencyButton.layer.backgroundColor = UIColor.red.cgColor
    }
    
    
    @IBAction func postEmergency(_ sender: UIButton) {
        
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 0
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 0
        
    }
    
    @IBAction func postEmergencyFinish(_ sender: UIButton) {
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 10
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 2
    }
    
    
    @IBAction func postEmergencyFinishOut(_ sender: UIButton) {
        
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 10
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 2
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func test(_ sender: Any) {
        print("test")
    }
    
}
