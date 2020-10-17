//
//  SearchVM.swift
//  Tango
//
//  Created by Samir Samanta on 08/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
class SearchVM {
    
    let apiService: SearchServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshViewNearFalseClosure: (() -> ())?
    var refreshprofileViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var searchDetails = SearchModel()
    var searchNearFarDetails = SearchModel()
    
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
    
    init( apiService: SearchServicesProtocol = SearchServices()) {
        self.apiService = apiService
    }
    
    func getSearchToAPIService(searchString: String, userID : String){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getSearchresultDetails(searchValue : searchString ,userID : userID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? SearchModel
                if  let getUserDetails = responseData {
                    self?.searchDetails = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getSearchresultNearByMeDetails(searchString: String, userID : String){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getSearchresultNearByMeDetails(searchValue : searchString ,userID : userID) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? SearchModel
                if  let getUserDetails = responseData {
                    self?.searchNearFarDetails = getUserDetails
                    self?.refreshViewNearFalseClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
