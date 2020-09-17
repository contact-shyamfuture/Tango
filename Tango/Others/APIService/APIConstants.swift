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
    static let baseURL = "http://166.62.54.122/swiggy/public/"
    
    static let loginURL = "oauth/token"
    static let otpURL = "api/user/otp"
    static let registerURL = "api/user/register"
    static let userCart = "api/user/cart"
    static let userCartList = "api/user/cart?nearBy="
    static let orderURL =  "api/user/order"
    static let addressURL =  "api/user/address"
    static let orderDetailsURL =  "api/user/order/"
    static let orderListsURL =  "api/user/ongoing/order"
    static let searchURL =  "api/user/search?user_id="
    static let disputeURL =  "api/user/dispute"
    static let topBannerURL =  "api/user/banner"
    static let safetyBannerURL =  "api/user/footer-banner"
    
    
    
    static func logInApi() -> String {
        return baseURL + loginURL
    }
    
    static func otpApi() -> String {
        return baseURL + otpURL
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
}
