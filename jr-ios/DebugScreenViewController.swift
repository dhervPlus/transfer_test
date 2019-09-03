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
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
        
        destinationName.text = "目的地：\(self.myString)"
        destinationName.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
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
    
    //MARK: Private Methods
    
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
        shapeLayer.lineWidth = 1.0

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
                if #available(iOS 13.0, *) {
                    print(self.mapImage.frame.size.width, (self.mapImage.image?.size.width)! / self.mapImage.frame.size.width)
                } else {
                    // Fallback on earlier versions
                }
                let mapWidth = self.mapImage.frame.width
                
                let mapHeight = self.mapImage.frame.height
                
                let natural_height = self.mapImage.image!.size.height
                
                let natural_width = self.mapImage.image!.size.width
                
                
                let loco_height = (natural_height * 800.0) / natural_width
                
                for i in self.nodes {
                    
                    
                    if #available(iOS 13.0, *) {
                        let image = UIImage(systemName: "gear")
                        let imageView = UIImageView(image: image!)
                        let x = round(CGFloat(i.x) * mapWidth)
                        let y = round(CGFloat(i.y) * mapHeight)
                        print(x, y)
                        imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                        self.mapImage.addSubview(imageView)
                    } else {
                        // Fallback on earlier versions
                    }
                    
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
                    self.drawLineFromPoint(start: start_point, toPoint: end_point, ofColor: UIColor.red, inView: self.mapImage)
                }
                
                for i in self.beacons {
                    
                    if #available(iOS 13.0, *) {
                        let image = UIImage(systemName: "circle.grid.hex")
                        
                        let imageView = UIImageView(image: image!)
                        let x = round((CGFloat(i.x) * mapWidth) / 800.0) - 10
                        let y = round((CGFloat(i.y) * mapHeight) / loco_height) - 10
                        
                        imageView.frame = CGRect(x: x, y: y, width: 20, height: 20)
                        imageView.tintColor = UIColor.red
                        self.mapImage.addSubview(imageView)
                        //                        self.mapView.bringSubviewToFront(imageView)
                    } else {
                        // Fallback on earlier versions
                    }
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
                    self.mapName.text = "現在のフロア：\(map_data.map.name)"
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
        let pathTableView = segue.destination as! PathTableViewController
        pathTableView.myString = self.myString
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


