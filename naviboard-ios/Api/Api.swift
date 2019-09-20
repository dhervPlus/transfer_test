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
    static let shared = Api(baseUrl: String("http://10.0.0.12:81/api"))
    
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get(path: String, completion: @escaping (Result<MapData, Error>) -> ()) {
        
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                //                self.handleClientError(error)
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
}

