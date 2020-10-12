//
//  SignUpModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
class SignUpVM {
    
    let apiService: SignUpServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var userDetails = UserResponse()
    var otpResponse = UserOTPResponse()
    var regisResponse = UserRegisterResponse()
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init( apiService: SignUpServicesProtocol = SignUpServices()) {
        self.apiService = apiService
    }
    
    func sendLoginCredentialsToAPIService(user: LoginParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.sendLoginDetails(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? UserResponse
                     if  let getUserDetails = responseData {
                         self?.userDetails = getUserDetails
                         self?.refreshViewClosure?()
                     } else {
                         self?.alertMessage = ""
                     }
                 } else {
                     self?.alertMessage = response.message
                 }
             }
         }
     }
    
     func validateUserInputs(user: LoginParam) -> [String: Any]? {
        
        guard let fname = user.username, !fname.isEmpty else {
            self.alertMessage = shouldEnterTheEmailName
            return nil
        }
        guard let password = user.password, !password.isEmpty else {
            self.alertMessage = shouldEnterThePassword
            return nil
        }
         return user.toJSON()
     }
    
    
    func sendOTPCredentialsToAPIService(user: OTPParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendOTPDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserOTPResponse
                    if  let getUserDetails = responseData {
                        self?.otpResponse = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func sendForgotOTPCredentialsToAPIService(user: OTPParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendOTPForForgotDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserOTPResponse
                    if  let getUserDetails = responseData {
                        self?.otpResponse = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    
    func validateUserInputs(user: OTPParam) -> [String: Any]? {
       
       guard let fname = user.phone, !fname.isEmpty else {
           self.alertMessage = shouldEnterTheEmailName
           return nil
       }
        return user.toJSON()
    }
    
    func sendRegisterCredentialsToAPIService(user: RegisterParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendRegisterDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserRegisterResponse
                    if  let getUserDetails = responseData {
                        self?.regisResponse = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    func validateUserInputs(user: RegisterParam) -> [String: Any]? {
        
       guard let fname = user.phone, !fname.isEmpty else {
           self.alertMessage = shouldEnterTheEmailName
           return nil
        }
        guard let email = user.email, !email.isEmpty else {
            self.alertMessage = enterValidEmailIDString
            return nil
        }
        guard user.email!.isValidEmail() else {
            self.alertMessage = enterValidEmailIDString
            return nil
        }
        guard let password = user.password, !password.isEmpty else {
            self.alertMessage = shouldEnterThePasswordName
            return nil
        }
        guard let password_confirmation = user.password_confirmation, !password_confirmation.isEmpty else {
            self.alertMessage = emptyConfirmPasswordField
            return nil
        }
        return user.toJSON()
    }
    
    func sendForgotResetCredentialsToAPIService(user: ChangePasswordParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendForgotChangePasswordDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserOTPResponse
                    if  let getUserDetails = responseData {
                        self?.otpResponse = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
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
    
    
    
    
    
}
