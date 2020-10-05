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

    @IBOutlet weak var SplachView: UIView!
    let logoAnimationView = LogoAnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SplachView.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
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
