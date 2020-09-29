//
//  UserResponse.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserResponse: Mappable {
    
    var token_type : String?
    var expires_in : Int?
    var access_token : String?
    var refresh_token : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
    }
}

class UserOTPResponse: Mappable {
    
    var message : String?
    var otp : Int?
    
    var id : Int?
    var forgotOtp : Int?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        otp <- map["otp"]
        
        id <- map["user.id"]
        forgotOtp <- map["user.otp"]
    }
}

class UserRegisterResponse: Mappable {

    var name : String?
    var email : String?
    var phone : String?
    
    var login_by : String?
    var social_unique_id : String?
    var id : Int?
    
    var msgPhone : [String]?
    

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        id <- map["id"]
        msgPhone <- map["phone"]
    }
}
