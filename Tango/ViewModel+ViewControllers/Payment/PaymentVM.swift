//
//  PaymentVM.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Foundation
class PaymentVM {
    
    let apiService: PaymentServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshTempViewClosure: (() -> ())?
    var refreshprofileViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var orderDetails = OrderDetailsModel()
    var tempOder = TempOrderSModel()
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
    
    init( apiService: PaymentServicesProtocol = PaymentServices()) {
        self.apiService = apiService
    }
    
    func postOrderToAPIService(user: OrderParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.postOrderDetails(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? OrderDetailsModel
                     if  let getUserDetails = responseData {
                         self?.orderDetails = getUserDetails
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
    
     func validateUserInputs(user: OrderParam) -> [String: Any]? {
         return user.toJSON()
     }
    
    
    func postTempOrderToAPIService(user: OrderParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postTempOrderDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? TempOrderSModel
                    if  let getUserDetails = responseData {
                        self?.tempOder = getUserDetails
                        self?.refreshTempViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    
    func postOnlineOrderToAPIService(user: OnlineOrderParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.postOrderDetails(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? OrderDetailsModel
                     if  let getUserDetails = responseData {
                         self?.orderDetails = getUserDetails
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
    
     func validateUserInputs(user: OnlineOrderParam) -> [String: Any]? {
         return user.toJSON()
     }
}
