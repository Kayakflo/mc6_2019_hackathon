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

    @IBOutlet weak var preView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func liftoff(_ sender: Any) {
        SocketController.singleton.initCommandClient()
        sleep(5)
        SocketController.singleton.initStreamServer { (cgImage) in
            DispatchQueue.main.async {
                self.preView.backgroundColor = UIColor(patternImage: UIImage(cgImage: cgImage))
            }
        }
    }    
}

