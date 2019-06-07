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
        }
    }
    
    func deinitCommandClient() {
        self.commandClient.close()
        self.commandClient = nil
    }
    
    func initStatusServer() {
        statusServer = UDPServer(address: "0.0.0.0", port: 8890)
        DispatchQueue.global(qos: .userInteractive).async {
            while true {
                let msg = self.statusServer.recv(1024)
            }
        }
    }
    
    func initStreamServer(onImage: @escaping (_ image: CGImage) -> ()) {
        if streamServer != nil { return }
        self.commandClient.send(string: "streamon")
        self.onImage = onImage
        streamServer = UDPServer(address: "0.0.0.0", port: 11111)
        let dec: VideoFrameDecoder = VideoFrameDecoder()
        var currentImg: [Byte] = []
        DispatchQueue.global(qos: .userInteractive).async {
            while true {
                let (data, remoteip, remoteport) = self.streamServer.recv(2048)
                if var d = data {
                    currentImg = currentImg + d
                    
                    if d.count < 1460 && currentImg.count > 40 {
                        VideoFrameDecoder.delegate = self
                        dec.interpretRawFrameData(&currentImg)
                        currentImg = []
                    }
                }
            }
        }
    }
    
    func deinitStreamServer() {
        self.commandClient.send(string: "streamoff")
        self.streamServer = nil
    }
    
    internal func receivedDisplayableFrame(_ frame: CVPixelBuffer) {
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
