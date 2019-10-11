//
//  EmergencyViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/09.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var circleContainer: UIButton!
    @IBOutlet weak var emergencyTitle: UILabel!
    @IBOutlet weak var emergencyText: UILabel!
    
    var current_language_table = Globals.current_language_table;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawCircle()
        emergencyTitle.text = NSLocalizedString("Emergency guide settings", tableName: current_language_table, comment: "emergency")
        emergencyText.text = NSLocalizedString("Press the button to switch the screen to emergency mode.", tableName: current_language_table, comment: "emergency")
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
    }
    
    @IBAction func postEmergency(_ sender: UIButton) {
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 0
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 0
        
        self.emergencyTrigger()
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
    
    func emergencyTrigger() {
        Api.shared.put(for: Emergency.self, path: "/emergency"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let emergency_data):
                if emergency_data.emergency {
                    let socket = Socket.shared.checkAliveSocket()
                    socket.emit("emergency", ["emergency": emergency_data.emergency])
                }
            }}
        
    }
}
