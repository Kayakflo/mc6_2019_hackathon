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
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func liftoff(_ sender: Any) {
        SocketController.singleton.initCommandClient()
        sleep(5)
        SocketController.singleton.initStreamServer { (byteData) in
            let data = Data(bytes: byteData, count: byteData.count)
            if  let urlString = String(data: data, encoding: String.Encoding.utf8) {
                let url = URL(string: urlString)
                
                if player == nil {
                    player = AVPlayer(url: url!)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    present(playerController, animated: true) {
                        self.player.play()
                    }
                } else {
                    print("Wer nicht will der hat schon!")
                }
            }

        }
    }    
}

