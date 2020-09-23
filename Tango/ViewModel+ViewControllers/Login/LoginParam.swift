//
//  LoginParam.swift
//  Tango
//
//  Created by Samir Samanta on 24/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class LoginParam: Mappable {

    var username : String?
    var password : String?
    var client_id : String?
    var grant_type : String?
    var client_secret : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
        client_id <- map["client_id"]
        grant_type <- map["grant_type"]
        client_secret <- map["client_secret"]
    }
}

class OTPParam: Mappable {

    var phone : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        phone <- map["phone"]
    }
}

class RegisterParam: Mappable {
    
    var name : String?
    var email : String?
    var phone : String?
    var password : String?
    var password_confirmation : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
    }
}

class CartParam: Mappable {
    
    var quantity : Int?
    var product_id : Int?
    var latitude : Double?
    var longitude : Double?
    var cart_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        quantity <- map["quantity"]
        product_id <- map["product_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        cart_id <- map["cart_id"]
    }
}

class OrderParam: Mappable {


    var note : String?
    var payment_mode : String?
    var wallet : String?
    var delivery_charge : String?
    var packaging_charge : String?
    var user_address_id : String?
    var tips_amount : String?
    var payment_id : String?
    var paymet_status : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        note <- map["note"]
        payment_mode <- map["payment_mode"]
        wallet <- map["wallet"]
        delivery_charge <- map["delivery_charge"]
        packaging_charge <- map["packaging_charge"]
        user_address_id <- map["user_address_id"]
        tips_amount <- map["tips_amount"]
        payment_id <- map["payment_id"]
        paymet_status <- map["paymet_status"]
        
    }
}

class ChangePasswordParam: Mappable {

    var id : Int?
    var password : String?
    var password_confirmation : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        password <- map["password"]
        password_confirmation <- map["password_confirmation"]
    }
}

class UpdateProfileParam: Mappable {

    var email : String?
    var name : String?
    var phone : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        name <- map["name"]
        phone <- map["phone"]
    }
}
