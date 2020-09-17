//
//  UserCratVM.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation

class UserCratVM {
    
    let apiService: UserCartServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshCartListViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var userCartDetails = UserCartModel()
    var userCartList = UserCartModel()
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
    
    init( apiService: UserCartServicesProtocol = UserCartServices()) {
        self.apiService = apiService
    }
    
    func sendUserCartToAPIService(user: CartParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.postUserCart(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? UserCartModel
                     if  let getUserDetails = responseData {
                         self?.userCartDetails = getUserDetails
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
    
     func validateUserInputs(user: CartParam) -> [String: Any]? {
         return user.toJSON()
     }
    
    func getUserCartListToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getUserCartDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? UserCartModel
                if  let getUserDetails = responseData {
                    self?.userCartList = getUserDetails
                    self?.refreshCartListViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
