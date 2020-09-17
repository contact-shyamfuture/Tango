//
//  ProfileEditVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 18/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ProfileEditVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tabBarView.isHidden = true
        headerView.imgLogo.isHidden = true
        headerView.btnBackAction.isHidden = false
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
    }
}
