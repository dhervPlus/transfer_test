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
    
    @IBOutlet weak var mapImage: UIImageView!
    
    var map: Map?
    var beacons = [Beacon]()
    var nodes = [Node]()
    var mapImageData = Data()
    var myString:String = String()
    
    @IBOutlet weak var mapName: UILabel!
    @IBOutlet weak var destinationName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
        
        destinationName.text = self.myString
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
                    self.mapName.text = map_data.map.name
                    self.beacons = map_data.beacons
                    self.nodes = map_data.nodes
                    
                }
            }
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


