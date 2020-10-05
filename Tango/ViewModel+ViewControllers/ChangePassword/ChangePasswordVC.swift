//
//  ChangePasswordVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var btnConfirmPassOutlet: UIButton!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnNewPassOutlet: UIButton!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var oldPassBtn: UIButton!
    @IBOutlet weak var txtOldPass: UITextField!
    var userID : Int?
    lazy var viewModel: SignUpVM = {
        return SignUpVM()
    }()
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var showAlertClosure: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        headerView.btnHeartOutlet.isHidden = true
        initializeViewModel()
    }
    
    @IBAction func btnActionOldpass(_ sender: Any) {
        if oldPassBtn.isSelected == true {
            oldPassBtn.isSelected = false
            txtOldPass.isSecureTextEntry = false
        }else{
            oldPassBtn.isSelected = true
            txtOldPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnNewPassAction(_ sender: Any) {
        if btnNewPassOutlet.isSelected == true {
            btnNewPassOutlet.isSelected = false
            txtNewPass.isSecureTextEntry = false
        }else{
            btnNewPassOutlet.isSelected = true
            txtNewPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnConfirmPassAction(_ sender: Any) {
        if btnConfirmPassOutlet.isSelected == true {
            btnConfirmPassOutlet.isSelected = false
            txtConfirmPass.isSecureTextEntry = false
        }else{
            btnConfirmPassOutlet.isSelected = true
            txtConfirmPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnChangePassConfirm(_ sender: Any) {
        
        let param = ChangePasswordParam()
        param.id = userID
        param.password = txtNewPass.text
        param.password_confirmation = txtConfirmPass.text
        
        if let params = self.validateUserInputs(user: param) {
            loginMethod(param : params)
        }
    }
    
    func validateUserInputs(user: ChangePasswordParam) -> [String: Any]? {
       
       guard let password = user.password, !password.isEmpty else {
           self.alertMessage = alertNewPassMessage
           return nil
       }
        guard let confirmPass = user.password_confirmation, !confirmPass.isEmpty else {
            self.alertMessage = alertNewConfirmPassMessage
            return nil
        }
        if user.password_confirmation != user.password {
            self.alertMessage = alertPasswordNotMatchMessage
        }
        return user.toJSON()
    }
    
    func loginMethod(param : [String: Any]){
        
        addLoaderView()
        let url = "http://166.62.54.122/swiggy/public/api/user/reset/password"
        //let header = ["Content-Type" : "text/html]
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default , headers: nil).responseString { response in
            self.removeLoaderView()
            print(response)
           // let json = response.result.value
            if response.response?.statusCode == 200 {
                    self.showAlertWithSingleButton(title: commonAlertTitle, message: "Password changed successfully", okButtonText: okText, completion: {
                        
                        self.navigationController!.popToRootViewController(animated: true)
                })
            }
         }
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
            }
        }
    }
}
