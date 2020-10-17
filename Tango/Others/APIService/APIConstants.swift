//
//  APIConstants.swift
//  LastingVideoMemories
//
//  Created by  Software Llp on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation
class APIConstants: NSObject {
    
    static let imgBaseURL = ""
    static let imgprescriptionBase = ""
   // static let baseURL = "http://166.62.54.122/swiggy/public/"
    static let baseURL = "http://tangoeateries.com/"
    
    static let loginURL = "oauth/token"
    static let otpURL = "api/user/otp"
    static let registerURL = "api/user/register"
    static let userCart = "api/user/cart"
    static let userCartList = "api/user/cart?nearBy="
    static let orderURL =  "api/user/order"
    static let addressURL =  "api/user/address"
    static let orderDetailsURL =  "api/user/order/"
    static let orderListsURL =  "api/user/ongoing/order"
    static let searchURL =  "api/user/searchn?user_id="
    static let disputeURL =  "api/user/dispute"
    static let topBannerURL =  "api/user/banner"
    static let safetyBannerURL =  "api/user/footer-banner"
    static let walletsURL =  "api/user/wallet"
    static let forgotOtpurl = "api/user/forgot/password"
    static let forgotReset = "api/user/reset/password"
    static let deleteAddress = "api/user/address/"
    static let filterURL = "api/user/cuisines"
    static let categoryURL = "api/user/categories?shop="
    static let tempOrderURL = "api/user/temp-order"
    static let promocodeURL = "api/user/wallet/promocode"
    static let favoritesListURL = "api/user/favorite"
    static let favoritesAddtURL = "api/user/favorite"
    static let checkLocationURL = "api/user/check-distance"
    static let oderCompletedURL = "api/user/order"
    static let deleteTmpURL = "api/user/temp-order/"
    
    
        
    static func logInApi() -> String {
        return baseURL + loginURL
    }
    
    static func otpApi() -> String {
        return baseURL + otpURL
    }
    
    static func forgotOtpApi() -> String {
        return baseURL + forgotOtpurl
    }
    
    static func forgotChangePasswordApi() -> String {
        return baseURL + forgotReset
    }
    
    static func registerApi() -> String {
        return baseURL + registerURL
    }
    static func userCartApi() -> String {
        return baseURL + userCart
    }
    
    static func userCartListApi() -> String {
        return baseURL + userCartList
    }
    static func orderApi() -> String {
        return baseURL + orderURL
    }
    
    static func addressApi() -> String {
        return baseURL + addressURL
    }
    
    static func orderDetailsApi() -> String {
        return baseURL + orderDetailsURL
    }
    
    static func orderListApi() -> String {
        return baseURL + orderListsURL
    }
    
    static func orderCompletedListApi() -> String {
        return baseURL + oderCompletedURL
    }
    
    static func searchApi() -> String {
        return baseURL + searchURL
    }
    static func orderDisputeApi() -> String {
        return baseURL + disputeURL
    }
    
    static func bannerApi() -> String {
        return baseURL + topBannerURL
    }
    
    static func safetyBannerApi() -> String {
        return baseURL + safetyBannerURL
    }
    
    static func walletsApi() -> String {
        return baseURL + walletsURL
    }
    
    static func filterApi() -> String {
        return baseURL + filterURL
    }
    
    static func deleteAddressApi() -> String {
        return baseURL + deleteAddress
    }
    
    static func getCategoryApi() -> String {
        return baseURL + categoryURL
    }
    
    static func postTempOrderApi() -> String {
        return baseURL + tempOrderURL
    }
    
    static func promoCodeApi() -> String {
        return baseURL + promocodeURL
    }
    
    static func favoritesApi() -> String {
        return baseURL + favoritesListURL
    }
    
    static func addFavoritesApi() -> String {
        return baseURL + favoritesListURL
    }
    
    static func checkLocationApi() -> String {
        return baseURL + checkLocationURL
    }
    
    static func deleteTempApi() -> String {
        return baseURL + deleteTmpURL
    }
}
