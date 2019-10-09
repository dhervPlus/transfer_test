//
//  Api.swift
//  naviboard-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation

class Api {
    
    public var map: MapData?
    static let shared = Api(baseUrl: String("http://13.231.244.58/public/api"))
    
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get(path: String, completion: @escaping (Result<MapData, Error>) -> ()) {
        
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let map_data = try JSONDecoder().decode(MapData.self, from: data)
                self.map = map_data
                completion(.success(map_data))
            } catch {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    //                self.handleServerError(response)
                    return
            }
        }
        return task.resume()
    }
    
    func post(path: String, myData: PathPostBody, completion: @escaping (Result<[PathData], Error>) -> ()) {
        
        let jsonData = try! JSONEncoder().encode(myData)
        
        // endpoint
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                print("URLSession dataTask error:", error ?? "nil")
                return
            }
            
            do {
                let jsonObject = try JSONDecoder().decode([PathData].self, from: data)
                completion(.success(jsonObject))
            } catch {
                print("JSONSerialization error:", error)
                completion(.failure(error))
            }
            
        }
        return task.resume()
    }
    
    func setEmergency(path: String, completion: @escaping (Result<Emergency, Error>) -> ()) {
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let emergency_mode = try JSONDecoder().decode(Emergency.self, from: data)
                
                
                completion(.success(emergency_mode))
            } catch {
                completion(.failure(error))
            }
            
        }
        return task.resume()
    }
}

