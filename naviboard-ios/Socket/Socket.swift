//
//  Socket.swift
//
//
//  Created by damien on 2019/10/09.
//

import Foundation
import SocketIO

class Socket {
    
    static let shared = Socket(url: String("http://54.64.251.38:3000"))
    
    var url: String
    var manager: SocketManager
    
    init(url: String) {
        self.url = url
        self.manager = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .compress])
    }
    
    func checkAliveSocket() -> SocketIOClient {
        let socket = self.manager.defaultSocket
        if(socket.status==SocketIOStatus.notConnected){
            socket.on(clientEvent: .connect) {data, ack in
                print("socket client connected")
            }
            socket.connect()
        }
        return socket
    }
    
}
