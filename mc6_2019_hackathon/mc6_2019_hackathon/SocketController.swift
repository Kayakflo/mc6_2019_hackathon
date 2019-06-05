//
//  SocketController.swift
//  mc6_2019_hackathon
//
//  Created by Florian Kriegel on 04.06.19.
//  Copyright © 2019 Florian Kriegel. All rights reserved.
//

import Foundation
import SwiftSocket
import VideoToolbox

class SocketController: VideoFrameDecoderDelegate {
    static var singleton: SocketController = SocketController()
    var commandClient: UDPClient!
    var streamServer: UDPServer!
    var statusServer: UDPServer!
    var onImage: (_ image: CGImage) -> () = { arg in }
    
    func initCommandClient() {
        if self.commandClient == nil {
            commandClient = UDPClient(address: "192.168.10.1", port: 8889)
            commandClient.send(string: "command")
            sleep(5)
            commandClient.send(string: "streamon")
            //commandClient.send(string: "takeoff")
            sleep(5)
            //commandClient.send(string: "land")
            commandClient.close()
        }
    }
    
    func initStatusServer() {
        statusServer = UDPServer(address: "0.0.0.0", port: 8890)
        while true {
            let msg = statusServer.recv(1024)
        }
    }
    
    func initStreamServer(onImage: @escaping (_ image: CGImage) -> ()) {
        self.onImage = onImage
        streamServer = UDPServer(address: "0.0.0.0", port: 11111)
        var currentImg: [Byte] = []
        DispatchQueue.global(qos: .background).async {
            while true {
                let (data, remoteip, remoteport) = self.streamServer.recv(2048)
                if var d = data {
                    currentImg = currentImg + d
                    
                    if d.count < 1460 && currentImg.count > 40 {
                        VideoFrameDecoder.delegate = self
                        let dec: VideoFrameDecoder = VideoFrameDecoder()
                        dec.interpretRawFrameData(&currentImg)
                        currentImg = []
                    }
                }
            }
        }
    }
    
    func receivedDisplayableFrame(_ frame: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            print("We have an image")
            self.onImage(cgImage)
        } else {
            print("Fail")
        }
    }
}
