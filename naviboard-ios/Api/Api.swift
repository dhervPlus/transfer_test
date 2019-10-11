//
//  Api.swift
//  naviboard-ios
//
//  Created by damien on 2019/08/24.
//  Copyright © 2019 beacrew. All rights reserved.
//

import Foundation


class Api {
    
    
    static let shared = Api(baseUrl: String("http://13.231.244.58/public/api"))
    
    var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get<T: Decodable>(for: T.Type = T.self, path: String, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            
            guard let data = data else {
                print("URLSession dataTask error:", error ?? "nil")
                return
            }
            
            do {
                let response_data = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response_data))
            } catch {
                completion(.failure(error))
            }
        }
        return task.resume()
    }
    
    func post<T: Decodable, P: Encodable>(for: T.Type = T.self, path: String, postData: P, completion: @escaping (Result<[T], Error>) -> ()) {
        
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        let jsonData = try! JSONEncoder().encode(postData)
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                print("URLSession dataTask error:", error ?? "nil")
                return
            }
            
            do {
                let response_data = try JSONDecoder().decode([T].self, from: data)
                completion(.success(response_data))
            } catch {
                print("JSONSerialization error:", error)
                completion(.failure(error))
            }
            
        }
        return task.resume()
    }
    
    func put<T: Decodable>(for: T.Type = T.self, path: String, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let endpoint = URL(string: (baseUrl + path)) else { return }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("URLSession dataTask error:", error ?? "nil")
                return
            }
            do {
                let response_data = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response_data))
            } catch {
                completion(.failure(error))
            }
            
        }
        return task.resume()
    }
}

