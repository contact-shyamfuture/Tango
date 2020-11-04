//
//  ViewController.swift
//  Tango
//
//  Created by Samir Samanta on 23/07/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import SwiftyGif

class ViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var SplachView: UIView!
    let logoAnimationView = LogoAnimationView()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        SplachView.addSubview(logoAnimationView)
//        logoAnimationView.pinEdgesToSuperView()
//        logoAnimationView.logoGifImageView.delegate = self
        
        let image = UIImage.gif(name: "splash_animation")
        self.splashImageView.image = image
        // Do any additional setup after loading the view.
        splashImageView.animationDuration = image!.duration
        splashImageView.animationRepeatCount = 0
       if timer == nil {
           timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.loop), userInfo: nil, repeats: true)
       }
    }
    
    @objc func loop() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openHomeViewController()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // logoAnimationView.logoGifImageView.startAnimatingGif()
    }
}

extension ViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
       
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openHomeViewController()
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
            
        }
    }
}
