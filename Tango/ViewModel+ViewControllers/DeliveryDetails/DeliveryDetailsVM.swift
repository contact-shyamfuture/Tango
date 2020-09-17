//
//  DeliveryDetailsVM.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation

class DeliveryDetailsVM {
    
    let apiService: OrderDetailsProtocol
    var refreshViewClosure: (() -> ())?
    var refreshOrderDisputeViewClosure: (() -> ())?
    var refreshOrderCancelViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var orderDetails = OrderSummeryModel()
    var orderDispute = OrderDisputeModel()
    var orderCancel = OrderCancelModel()
    
    
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
    
    init( apiService: OrderDetailsProtocol = OrderDetailsServices()) {
        self.apiService = apiService
    }
    
    func getAddressList(id : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getOrderDetailsDetails(OrderID: id, params: [:]) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? OrderSummeryModel
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
    
    func getOrderDisputeResponse(params : [String:Any]){
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getOrderDispute(params: params) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? OrderDisputeModel
                if  let getUserDetails = responseData {
                    self?.orderDispute = getUserDetails
                    self?.refreshOrderDisputeViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getOrderCancel(id : String,reasondesc : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getOrderCancel(OrderID: id, reason: reasondesc, params: [:]) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? OrderCancelModel
                if  let getUserDetails = responseData {
                    self?.orderCancel = getUserDetails
                    self?.refreshOrderCancelViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
}
