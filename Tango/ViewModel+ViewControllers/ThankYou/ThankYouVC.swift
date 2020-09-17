//
//  ThankYouVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ThankYouVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tabBarView.isHidden = true
        headerView.imgLogo.isHidden = false
        headerView.btnBackAction.isHidden = true
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
    }
    @IBAction func btnTrackOrderAction(_ sender: Any) {
    }
    
    @IBAction func btnDashboardAction(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
