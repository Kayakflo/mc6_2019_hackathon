//
//  ViewController.swift
//  mc6_2019_hackathon
//
//  Created by Florian Kriegel on 04.06.19.
//  Copyright © 2019 Florian Kriegel. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    var videoOn = false
    
    @IBOutlet weak var preView: UIImageView!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var video_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initJoystick()
        self.initSockets()
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
    
    func initJoystick() {
        let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        skView.backgroundColor = transparent
        
        let scene = SKScene(size: skView.bounds.size)
        scene.backgroundColor = transparent
        scene.anchorPoint = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let backgroundNode: SKSpriteNode = SKSpriteNode(color: transparent, size: skView.bounds.size)
        
        let leftStick = TLAnalogJoystick(withDiameter: 100)
        leftStick.position = CGPoint(x: (backgroundNode.size.width / -2) + 150, y: (backgroundNode.size.height / -2) + 100)
        
        let rightStick = TLAnalogJoystick(withDiameter: 100)
        rightStick.position = CGPoint(x: (backgroundNode.size.width / 2) - 150, y: (backgroundNode.size.height / -2) + 100)

        backgroundNode.addChild(leftStick)
        backgroundNode.addChild(rightStick)
        
        scene.addChild(backgroundNode)
        
        skView.presentScene(scene)
    }
    
    func initSockets() {
        SocketController.singleton.initCommandClient()
        SocketController.singleton.initStatusServer()
    }

    @IBAction func liftoff(_ sender: Any) {
        SocketController.singleton.initStreamServer { (cgImage) in
            DispatchQueue.main.async {
                self.preView.image = UIImage(cgImage: cgImage)
            }
        }
    }    
}

