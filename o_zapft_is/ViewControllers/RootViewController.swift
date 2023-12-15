//
//  RootViewController.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 14.12.23.
//

import UIKit
import CoreMotion

class RootViewController: UIViewController, Storyboarded {
    weak var coordinator: RootCoordinator?
    
    var manager = CMMotionManager()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBAction func showList(_ sender: Any) {
        
        self.coordinator?.showBeerList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.titleView.layer.cornerRadius = 10
        
        initMotion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        manager.stopAccelerometerUpdates()
        
        super.viewDidDisappear(animated)
    }
    
    
    
    func initMotion() {
        
        guard manager.isAccelerometerAvailable else {
            return
        }
        
        manager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            let rotation = atan2(data.gravity.x,
                                 data.gravity.y) - .pi
            self.backgroundImage.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }
    }


}

