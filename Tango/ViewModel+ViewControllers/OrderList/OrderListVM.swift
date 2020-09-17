//
//  OrderListVM.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation

class OrderListVM {
    
    let apiService: OrderListProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var orderList = [OrderListModel]()
    
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
    
    init( apiService: OrderListProtocol = OrderListServices()) {
        self.apiService = apiService
    }
    
    func getOrderList() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getOrderListDetails(params: [:]) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? [OrderListModel]
                if  let getUserDetails = responseData {
                    self?.orderList = getUserDetails
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
