//
//  AddressListVM.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation

class AddressListVM {
    
    let apiService: AddressServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshDeleteViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var addressList = [AddressListModel]()
    var deleteAdd = AddressSaveModel()
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
    
    init( apiService: AddressServicesProtocol = AddressServices()) {
        self.apiService = apiService
    }
    
    func getAddressList() {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
             self.isLoading = true
        self.apiService.getAddressDetails(params: [:]) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? [AddressListModel]
                     if  let getUserDetails = responseData {
                         self?.addressList = getUserDetails
                         self?.refreshViewClosure?()
                     } else {
                         self?.alertMessage = "Failed"
                     }
                 } else {
                     self?.alertMessage = response.message
                 }
             }
     }
    
    func deleteAddressDetails(id : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
            self.isLoading = true
        self.apiService.deleteAddressDetails(addressID: id) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AddressSaveModel
                    if  let getUserDetails = responseData {
                        self?.deleteAdd = getUserDetails
                        self?.refreshDeleteViewClosure?()
                    } else {
                        self?.alertMessage = "Failed"
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
    }
    
    
}
