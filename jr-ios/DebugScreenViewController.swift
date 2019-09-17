//
//  DebugScreenViewController.swift
//  jr-ios
//
//  Created by damien on 2019/08/31.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}


class DebugScreenViewController: UIViewController {
    
    @IBOutlet weak var NavLeftButton: UIBarButtonItem!
    @IBOutlet weak var NavRightButton: UIBarButtonItem!
    
    @IBOutlet weak var mapImage: UIImageView!
    
    var map: Map?
    var beacons = [Beacon]()
    var nodes = [Node]()
    var edges = [Edge]()
    var mapImageData = Data()
    var myString:String = String()
    var current_table = String()
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var guideBoard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap()
        
        
        NavLeftButton.title = NSLocalizedString("Back", tableName: current_table, comment: "navigation-item")
        navigation.title = NSLocalizedString("Debug", tableName: current_table, comment: "navigation-title")
        destinationName.attributedText = self.indent( string: "\(NSLocalizedString("Destination:", tableName: current_table, comment: "global")) \(myString)")
        guideBoard.layer.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        guideBoard.attributedText = self.indent(string: NSLocalizedString("Guide board display information", tableName:current_table, comment: "page-debug"))
        
        destinationName.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let owningNavigationController = navigationController{owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The Icon Page Controller is not inside a navigation controller.")
        }
    }
    
    //MARK: Private Methods
    
    private func indent(string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(
            string: string ,
            attributes: attributes)
        
        
        
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
        
        view.layer.addSublayer(shapeLayer)
    }
    
    
    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            self.mapImageData = data
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.mapImage.image = UIImage(data: data)
                //                if #available(iOS 13.0, *) {
                //                    print(self.mapImage.frame.size.width, (self.mapImage.image?.size.width)! / self.mapImage.frame.size.width)
                //                } else {
                //                    // Fallback on earlier versions
                //                }
                let mapWidth = self.mapImage.frame.width
                
                let mapHeight = self.mapImage.frame.height
                
                let natural_height = self.mapImage.image!.size.height
                
                let natural_width = self.mapImage.image!.size.width
                
//
                let iphonePosition = Cursor(x: 0.55, y: 0.33)
                let cursor = UIImage(named: "cursor")
                let imageView = UIImageView(image: cursor!)
                let x = round(CGFloat(iphonePosition!.x) * mapWidth)
                let y = round(CGFloat(iphonePosition!.y) * mapHeight)
                
                print("here", x, y)

                imageView.frame = CGRect(x: x, y: y, width: 60 , height: 60)
                imageView.layer.zPosition = 5
                self.mapImage.addSubview(imageView)
                
                let loco_height = (natural_height * 800.0) / natural_width
                
                for i in self.nodes {
                    
                    
                    
                    let image = UIImage(named: "node")
                    let imageView = UIImageView(image: image!)
                    print("node", i.x, i.y)
                    let x = round(CGFloat(i.x) * mapWidth)
                    let y = round(CGFloat(i.y) * mapHeight)
                   
                    
                    imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                    imageView.layer.zPosition = 1
                    self.mapImage.addSubview(imageView)
                    
                    
                }
                
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
                    print(start_point, end_point)
                    self.drawLineFromPoint(start: start_point, toPoint: end_point, ofColor: UIColor(red:0.94, green:0.78, blue:0.36, alpha:1.0), inView: self.mapImage)
                }
                
                for i in self.beacons {
                    
                    
                    let image = UIImage(named: "target")
                    
                    let imageView = UIImageView(image: image!)
                    let x = round((CGFloat(i.x) * mapWidth) / 800.0) - 10
                    let y = round((CGFloat(i.y) * mapHeight) / loco_height) - 10
                    
                    imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                    
                    imageView.layer.zPosition = 2
                    self.mapImage.addSubview(imageView)
                    
                }
            }
        }}
    
    
    
    private func loadMap() {
        Api.shared.get(path: "/loadmap/16"){(res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let map_data):
                print(map_data)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.myString)
        if segue.identifier == "seguetoPathView" {
            let pathTableView = segue.destination as! PathTableViewController
            pathTableView.myString = self.myString
            pathTableView.current_table = self.current_table
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


