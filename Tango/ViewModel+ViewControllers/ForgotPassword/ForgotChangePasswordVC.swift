//
//  ForgotChangePasswordVC.swift
//  Tango
//
//  Created by Samir Samanta on 19/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import Alamofire

class ForgotChangePasswordVC: UIViewController {

    @IBOutlet weak var btnConfirmPassOutlet: UIButton!
    @IBOutlet weak var btnNewPassOutlet: UIButton!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    var phoneNumbr : String?
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
        txtNewPassword.isSecureTextEntry = false
        txtConfirmPassword.isSecureTextEntry = false
        initializeViewModel()
    }
    
    @IBAction func btnNewPasswordEye(_ sender: Any) {
        if btnNewPassOutlet.isSelected == true {
            btnNewPassOutlet.isSelected = false
            txtNewPassword.isSecureTextEntry = false
        }else{
            txtNewPassword.isSecureTextEntry = true
            btnNewPassOutlet.isSelected = true
        }
    }
    
    @IBAction func btnConfirmPasswordEye(_ sender: Any) {
        
        if btnConfirmPassOutlet.isSelected == true {
            btnConfirmPassOutlet.isSelected = false
            txtConfirmPassword.isSecureTextEntry = false
        }else{
            txtConfirmPassword.isSecureTextEntry = true
            btnConfirmPassOutlet.isSelected = true
        }
    }
    
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        let param = ChangePasswordParam()
        param.id = userID
        param.password = txtNewPassword.text
        param.password_confirmation = txtConfirmPassword.text
        
        if let params = self.validateUserInputs(user: param) {
            loginMethod(param : params)
        }
    }
    
    func loginMethod(param : [String: Any]){
        
        addLoaderView()
        let url = "http://tangoeateries.com/api/user/reset/password"
        //let header = ["Content-Type" : "text/html]
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default , headers: nil).responseString { response in
            self.removeLoaderView()
            print(response)
           // let json = response.result.value
            if response.response?.statusCode == 200 {
                    self.showAlertWithSingleButton(title: commonAlertTitle, message: "Password changed successfully", okButtonText: okText, completion: {
                        
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: LoginVC.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                })
            }
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
                
                if  (self?.viewModel.otpResponse.otp) != nil {
                    
                    
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}
