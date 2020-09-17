//
//  DeliveryLocationAddVM.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation

class DeliveryLocationAddVM {
    
    let apiService: AddressServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var addressSave = AddressSaveModel()
    
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
    
    func getAddressSaveResponse(param : AddressSaveParamModel) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
        if let params = self.validateUserInputs(user: param){
            self.isLoading = true
            self.apiService.getAddressSaveDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AddressSaveModel
                    if  let getUserDetails = responseData {
                        self?.addressSave = getUserDetails
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
    func validateUserInputs(user: AddressSaveParamModel) -> [String: Any]? {
        return user.toJSON()
    }
    
}
