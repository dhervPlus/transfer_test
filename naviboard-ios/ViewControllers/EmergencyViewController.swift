//
//  EmergencyViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/09/09.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit
import SocketIO

class EmergencyViewController: UIViewController {
    
    @IBOutlet weak var circleContainer: UIButton!
    @IBOutlet weak var emergencyTitle: UILabel!
    @IBOutlet weak var emergencyText: UILabel!
    
    var current_table = String();
    
    
    //MARK: Socker Manager
    let manager = SocketManager(socketURL: URL(string: "http://10.0.0.17:3000")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawCircle()
        
        emergencyTitle.text = NSLocalizedString("Emergency guide settings", tableName: current_table, comment: "emergency")
        emergencyText.text = NSLocalizedString("Press the button to switch the screen to emergency mode.", tableName: current_table, comment: "emergency")
        
        checkAliveSocket()
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
        
    }
    
    
    @IBAction func postEmergency(_ sender: UIButton) {
        
        circleContainer.layer.shadowColor = UIColor.black.cgColor
        circleContainer.layer.shadowOpacity = 0
        circleContainer.layer.shadowOffset = .zero
        circleContainer.layer.shadowRadius = 0
        
        self.setEmergency()
        
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
    
    //MARK: Socket
    
    //   if working on local and socket stuck in "connecting", check the network url (should be ip address of local server) and iphone/server on same wifi
    func checkAliveSocket() {
        socket = manager.defaultSocket
        if(socket!.status==SocketIOStatus.notConnected){
            socket.on(clientEvent: .connect) {data, ack in
                //                self.socket.emit("message_room", "connected")
                print("SOCKET")
            }
            socket.connect()
        }
        
    }
    
    func setEmergency() {
        print("setEmergency")
        Api.shared.setEmergency(path: "/emergency"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let emergency_data):
                print("EMER", emergency_data, self.socket.status)
                if emergency_data.emergency {
                    self.socket.emit("emergency", ["emergency": emergency_data.emergency])
                }
            }}
        
    }
    
}
