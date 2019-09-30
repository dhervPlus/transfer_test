//
//  DebugScreenViewController.swift
//  naviboard-ios
//
//  Created by damien on 2019/08/31.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit
import BeacrewLoco



struct PostData: Codable {
    var map_id: Int
    var node_start_id: Int
    var node_end_id: Int
}

class DebugScreenViewController: UIViewController, BCLManagerDelegate, UpdatePathTable {
    var map: Map?
    var beacons = [Beacon]()
    var nodes = [Node]()
    var edges = [Edge]()
    
    //    var mapImageData = Data()
    var destination_name:String = String()
    var current_table = String()
    var cursor: Cursor = Cursor(x:0, y:0)!
    
    
    // MARK: Path
    
    var path = [PathData]()
    var selectedDestination: Destination? = nil
    var current_beacon_id = ""
    
    
    
    @IBOutlet weak var Location_X: UILabel!
    @IBOutlet weak var Location_Y: UILabel!
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var guideBoard: UILabel!
    @IBOutlet weak var NavLeftButton: UIBarButtonItem!
    @IBOutlet weak var NavRightButton: UIBarButtonItem!
    
    @IBOutlet weak var mapImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: UI setup
        NavLeftButton.title = NSLocalizedString("Back", tableName: current_table, comment: "navigation-item")
        navigation.title = NSLocalizedString("Debug", tableName: current_table, comment: "navigation-title")
        
        guideBoard.layer.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        guideBoard.attributedText = self.indent(string: NSLocalizedString("Guide board display information", tableName:current_table, comment: "page-debug"))
        
        destinationName.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        destinationName.attributedText = self.indent( string: "\(NSLocalizedString("Destination:", tableName: current_table, comment: "global")) \(destination_name)")
        
        //MARK: load functions
//        loadMap()
        
    }
        
    
    //MARK: BCL functions
    
    func afterBeacon(beacons: [BCLBeacon]!, position: Estimate) {
        
        DispatchQueue.main.async {
            
            self.Location_X.text = String(describing:position.x)
            self.Location_Y.text = String(describing:position.y)
            
            let x = Double(String(describing:position.x))!
            let y = Double(String(describing:position.y))!
            
            self.setCursorPosition(x:x, y:y)
            
            // prevent from calling loadmap every second on get beacon signal
            if(self.current_beacon_id == "") {
                self.current_beacon_id = beacons.first!.beaconId
                self.loadMap(beacon_id: beacons.first!.beaconId)
            }
            
        }
        
    }
    
    
    //MARK: IB functions
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The Icon Page Controller is not inside a navigation controller.")
        }
    }
    
    //MARK: Private Methods
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    private func indent(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(
            string: string ,
            attributes: attributes)
    }
    
    
    private func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 3.0
        
        // Add line to layer
        view.layer.addSublayer(shapeLayer)
    }
    
    
    private func setCursorPosition(x: Double, y: Double) {
        
        if self.mapImage.image != nil {
            let natural_height = self.mapImage.image!.size.height
            let natural_width = self.mapImage.image!.size.width
            let loco_height = (natural_height * 800.0) / natural_width
            
            // if view with tag 100 is already here, remove it. Otherwise cursor will keep being added to the view
            // else setup cursor and add it to view with tag 100
            if let viewWithTag = self.view.viewWithTag(100) {
                let x = round((CGFloat(x) * self.mapImage.frame.width) / 800.0) - 10
                let y = round((CGFloat(y) * self.mapImage.frame.height) / loco_height) - 10
                viewWithTag.frame = CGRect(x: x - 15, y: y - 15, width: 60 , height: 60)
            } else {
                let cursor = UIImage(named: "cursor")
                let imageView = UIImageView(image: cursor!)
                imageView.tag = 100
                let x = round((CGFloat(x) * self.mapImage.frame.width) / 800.0) - 10
                let y = round((CGFloat(y) * self.mapImage.frame.height) / loco_height) - 10
                imageView.frame = CGRect(x: x - 15, y: y - 15, width: 60 , height: 60)
                imageView.layer.zPosition = 5
                imageView.alpha = 0
                self.mapImage.addSubview(imageView)
                
                UIView.animate(withDuration: 0.5, animations: {
                    imageView.alpha = 1
                })
            }
        } else {
            return
        }
        
        
        
    }
    
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                
                // MARK: Add image
                self.mapImage.image = UIImage(data: data)
                let mapWidth = self.mapImage.frame.width
                let mapHeight = self.mapImage.frame.height
                let natural_height = self.mapImage.image!.size.height
                let natural_width = self.mapImage.image!.size.width
                let loco_height = (natural_height * 800.0) / natural_width
                
                // MARK: Add nodes to image view
                for i in self.nodes {
                    let image = UIImage(named: "node")
                    let imageView = UIImageView(image: image!)
                    let x = round(CGFloat(i.x) * mapWidth)
                    let y = round(CGFloat(i.y) * mapHeight)
                    imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                    imageView.layer.zPosition = 1
                    self.mapImage.addSubview(imageView)
                }
                
                // MARK: Add beacons to image view
                for i in self.beacons {
                    let image = UIImage(named: "target")
                    let imageView = UIImageView(image: image!)
                    let x = round((CGFloat(i.x) * mapWidth) / 800.0) - 10
                    let y = round((CGFloat(i.y) * mapHeight) / loco_height) - 10
                    imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                    imageView.layer.zPosition = 2
                    self.mapImage.addSubview(imageView)
                }
                
                // MARK: Add edges to image view
                for i in self.edges {
                    
                    let start = self.nodes.first(where: { $0.id == i.node_start_id })
                    let end = self.nodes.first(where: {
                        $0.id == i.node_end_id
                    })
                    let start_x = Double(round(CGFloat(start!.x) * mapWidth)) + 10
                    let start_y = Double(round(CGFloat(start!.y) * mapHeight)) + 10
                    let end_x = Double(round(CGFloat(end!.x) * mapWidth)) + 10
                    let end_y = Double(round(CGFloat(end!.y) * mapHeight)) + 10
                    let start_point = CGPoint.init(x: start_x, y: start_y)
                    let end_point = CGPoint.init(x:end_x, y:end_y)
                    self.drawLineFromPoint(start: start_point, toPoint: end_point, ofColor: UIColor(red:0.94, green:0.78, blue:0.36, alpha:1.0), inView: self.mapImage)
                }
                
            }
        }}
    
    
    // MARK: load functions
    
    private func loadMap(beacon_id: String) {
        Api.shared.get(path: "/map/current/\(beacon_id)"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                self.map = map_data.map
                self.downloadImage(from: map_data.map.image)
                DispatchQueue.main.async {
                    self.mapName.attributedText = self.indent(string: "\(NSLocalizedString("Current Floor:", tableName: self.current_table, comment: "page-debug")) \(map_data.map.name)")
                    self.mapName.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
                    self.beacons = map_data.beacons
                    self.nodes = map_data.nodes
                    self.edges = map_data.edges
                    
                }
            }
        }
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetoPathView" {
            let pathTableView = segue.destination as! PathTableViewController
            pathTableView.delegate = self
            pathTableView.destination_name = self.destination_name
            pathTableView.current_table = self.current_table
            pathTableView.pathData = self.path
            pathTableView.selectedDestination = self.selectedDestination
            pathTableView.tableView.reloadData()
            
        } else {
            let emergencyView = segue.destination as! EmergencyViewController
            emergencyView.current_table = self.current_table
        }
        
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


