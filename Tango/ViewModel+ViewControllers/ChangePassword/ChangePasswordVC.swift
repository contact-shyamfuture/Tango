//
//  ChangePasswordVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var btnConfirmPassOutlet: UIButton!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnNewPassOutlet: UIButton!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var oldPassBtn: UIButton!
    @IBOutlet weak var txtOldPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionOldpass(_ sender: Any) {
    }
    @IBAction func btnNewPassAction(_ sender: Any) {
    }
    @IBAction func btnConfirmPassAction(_ sender: Any) {
    }
    @IBAction func btnChangePassConfirm(_ sender: Any) {
    }
}
