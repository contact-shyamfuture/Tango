//
//  DashboardVM.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Foundation
class DashboardVM {
    
    let apiService: DashboradServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshprofileViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var refreshToBannerViewClosure: (() -> ())?
    var refreshSafetyBannerViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var restaurantModel = RestaurantModel()
    var userdetails = ProfiledetailsModel()
    var topBanner = [TopBannerModel]()
    var safetyBanner = [SafetyModel]()
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
    
    init( apiService: DashboradServicesProtocol = DashboradServices()) {
        self.apiService = apiService
    }
    
    func getDashboardToAPIService(lat: String, long : String, id : String ){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getRestaurantListDetails(lat : lat, long : long, id : id) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? RestaurantModel
                if  let getUserDetails = responseData {
                    self?.restaurantModel = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getProfileDetailsAPIService(device_type : String, device_token : String, device_id : String){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getProfileDetails(device_type : device_type, device_token : device_token, device_id : device_id) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? ProfiledetailsModel
                if  let getUserDetails = responseData {
                    self?.userdetails = getUserDetails
                    self?.refreshprofileViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getTopBannerAPIService(){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getTopBanner() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? [TopBannerModel]
                if  let getUserDetails = responseData {
                    self?.topBanner = getUserDetails
                    self?.refreshToBannerViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getSafetyBannerAPIService(){
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        self.isLoading = true
        self.apiService.getSafetyBanner() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? [SafetyModel]
                if  let getUserDetails = responseData {
                    self?.safetyBanner = getUserDetails
                    self?.refreshSafetyBannerViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
}
