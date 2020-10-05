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
    var refreshFavoritesListViewClosure: (() -> ())?
    var refreshAddFavoritesViewClosure: (() -> ())?
    var refreshRemoveFavoritesViewClosure: (() -> ())?
    var refreshCategoryListViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var refreshLocationCheckViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    var userCartDetails = UserCartModel()
    var userCartList = UserCartModel()
    var favoritesDetails = FavoritesModel()
    var categoryList : RestaurantList?
    var addFavDetails = FavoritesAdd()
    var checkDis = LocationCheck()
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
    
    func getCategoryListToAPIService(shopID : String, user_id : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getCategoryDetails(shopID : shopID, user_id : user_id) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? RestaurantList
                if  let getUserDetails = responseData {
                    self?.categoryList = getUserDetails
                    self?.refreshCategoryListViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getFavoritesListToAPIService() {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getFavoriteList() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? FavoritesModel
                if  let getUserDetails = responseData {
                    self?.favoritesDetails = getUserDetails
                    self?.refreshFavoritesListViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func addFavoritesToAPIService(user: AddFavParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.addFavoriteList(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? FavoritesAdd
                     if  let getUserDetails = responseData {
                         self?.addFavDetails = getUserDetails
                         self?.refreshAddFavoritesViewClosure?()
                     } else {
                         self?.alertMessage = ""
                     }
                 } else {
                     self?.alertMessage = response.message
                 }
             }
         }
     }
    
     func validateUserInputs(user: AddFavParam) -> [String: Any]? {
         return user.toJSON()
     }
    
    func removeFavoritesToAPIService(shopId : String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.removeFavoriteList(shopId: shopId) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? FavoritesAdd
                if  let getUserDetails = responseData {
                    self?.addFavDetails = getUserDetails
                    self?.refreshRemoveFavoritesViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func CheckLocationToAPIService(user: CheckLocationParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.postcheckDistance(params: params) { [weak self] (response) in
                 self?.isLoading = false
                 if response.responseStatus == .success {
                     let responseData = response.data as? LocationCheck
                     if  let getUserDetails = responseData {
                         self?.checkDis = getUserDetails
                         self?.refreshLocationCheckViewClosure?()
                     } else {
                         self?.alertMessage = ""
                     }
                 } else {
                     self?.alertMessage = response.message
                 }
             }
         }
     }
    
     func validateUserInputs(user: CheckLocationParam) -> [String: Any]? {
         return user.toJSON()
     }
}
