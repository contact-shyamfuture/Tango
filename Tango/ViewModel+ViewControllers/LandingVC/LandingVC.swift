//
//  LandingVC.swift
//  Tango
//
//  Created by Samir Samanta on 03/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ImageSlideshow

class LandingVC: UIViewController {
    
    @IBOutlet weak var btnSignOutlet: UIButton!
    @IBOutlet weak var btnRegisterOutlet: UIButton!
    @IBOutlet var slideshow: ImageSlideshow!
    let localSource = [BundleImageSource(imageString: "intro_1"), BundleImageSource(imageString: "intro_2"), BundleImageSource(imageString: "intro_3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignOutlet.layer.cornerRadius = btnSignOutlet.frame.height/2
        btnRegisterOutlet.layer.cornerRadius = btnRegisterOutlet.frame.height/2
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 250/255.0, green: 128/255.0, blue: 0/255.0, alpha: CGFloat(1))//UIColor(red: 250/255.0, green: 128/255.0, blue: 0/255.0, alpha: CGFloat(1))//UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.blue ///UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        //carbol
        slideshow.setImageInputs(localSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(LandingVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "RegisterWithMobileVC") as! RegisterWithMobileVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    
    @IBAction func btnSkipAction(_ sender: Any) {
        let mainView = UIStoryboard(name:"Dashboard", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
}

extension LandingVC: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}
