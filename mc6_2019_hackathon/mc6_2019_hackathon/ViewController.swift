//
//  ViewController.swift
//  mc6_2019_hackathon
//
//  Created by Florian Kriegel on 04.06.19.
//  Copyright © 2019 Florian Kriegel. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    var videoOn = false
    
    @IBOutlet var debugLabel: UILabel!
    @IBOutlet weak var preView: UIImageView!
    @IBOutlet weak var video_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSockets()
        APIController.shared.stateUpdate = { byte, string, int in
            DispatchQueue.main.async{
                 self.debugLabel.text = "\(byte) \(string) \(int)"
            }
        }
    }
    
    @IBAction func video_btn(_ sender: Any) {
        if videoOn {
            SocketController.singleton.deinitStreamServer()
            self.video_btn.setBackgroundImage(UIImage(named: "video_off"), for: .normal)
        } else {
            self.video_btn.setBackgroundImage(UIImage(named: "video_on"), for: .normal)
            SocketController.singleton.initStreamServer { (cgImage) in
                DispatchQueue.main.async {
                    self.preView.image = UIImage(cgImage: cgImage)
                }
            }
        }
        self.videoOn = !self.videoOn
    }
    
    @IBAction func emergency_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .EMERGENCY, params: nil, response: {bool in})
    }
    
    @IBAction func land_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .LAND, params: nil, response: {bool in})
    }
    
    @IBAction func flip_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .FLIP, params: Character("r"), response: {bool in})
    }
    
    @IBAction func forward_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .FORWARD, params: 20, response: {bool in})
    }
    
    @IBAction func left_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .LEFT, params: 20, response: {bool in})
    }
    
    @IBAction func back_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .BACK, params: 20, response: {bool in})
    }
    
    @IBAction func right_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .RIGHT, params: 20, response: {bool in})
    }
    
    @IBAction func takeoff_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .TAKEOFF, params: nil, response: {bool in})
    }
    
    @IBAction func up_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .UP, params: 20, response: {bool in})
    }
    
    @IBAction func down_btn(_ sender: Any) {
        APIController.shared.sendWriteCommand(command: .DOWN, params: 20, response: {bool in})
    }
    
    @IBAction func stats_btn(_ sender: Any) {
        APIController.shared.sendReadCommand(command: .BATTERY, response: {bool in})
    }
    
    func initSockets() {
        SocketController.singleton.initCommandClient()
        SocketController.singleton.initStatusServer()
        SocketController.singleton.initCommandServer()
    }   
}

