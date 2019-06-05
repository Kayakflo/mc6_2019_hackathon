//
//  SocketController.swift
//  mc6_2019_hackathon
//
//  Created by Florian Kriegel on 04.06.19.
//  Copyright © 2019 Florian Kriegel. All rights reserved.
//

import Foundation
import SwiftSocket

class SocketController {
    static var singleton: SocketController = SocketController()
    var commandClient: UDPClient!
    var streamServer: UDPServer!
    var statusServer: UDPServer!
    
    func initCommandClient() {
        if self.commandClient == nil {
            commandClient = UDPClient(address: "192.168.10.1", port: 8889)
            commandClient.send(string: "command")
            sleep(5)
            commandClient.send(string: "streamon")
            commandClient.send(string: "takeoff")
            sleep(5)
            commandClient.send(string: "land")
            commandClient.close()
        }
    }
    
    func initStatusServer() {
        statusServer = UDPServer(address: "0.0.0.0", port: 8890)
        while true {
            let msg = statusServer.recv(1024)
        }
    }
    
    func initStreamServer(onData: ([Byte]) -> ()) {
        streamServer = UDPServer(address: "0.0.0.0", port: 11111)
        var currentImg: [Byte] = []
        while true {
            let (data, remoteip, remoteport) = streamServer.recv(2048)
            if let d = data {
                if d.count == 1460 {
                    if currentImg.count == 0 {
                        print("START FOUND")
                        currentImg = d
                    } else {
                        currentImg = currentImg + d
                        print("Part")
                    }
                } else if d.count < 1460 {
                    currentImg = currentImg + d
                    print("END FOUND")
                    currentImg = []
                }
//                onData(d)
            }
        }
    }
}
