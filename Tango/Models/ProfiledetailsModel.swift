//
//  ProfiledetailsModel.swift
//  Tango
//
//  Created by Samir Samanta on 26/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProfiledetailsModel: Mappable {
    
    var id : Int?
    var name : String?
    var email : String?
    var phone : String?
    var avatar : String?
    var device_token : String?
    var device_id : String?
    var device_type : String?
    var login_by : String?
    var social_unique_id : String?
    var stripe_cust_id : String?
    var wallet_balance : Int?
    var otp : String?
    var braintree_id : String?
    var currency : String?
    var payment_mode : [String]?
    var userCart : [ProfileCartModel]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        avatar <- map["avatar"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        device_type <- map["device_type"]
        login_by <- map["login_by"]
        social_unique_id <- map["social_unique_id"]
        stripe_cust_id <- map["stripe_cust_id"]
        wallet_balance <- map["wallet_balance"]
        otp <- map["otp"]
        braintree_id <- map["braintree_id"]
        currency <- map["currency"]
        payment_mode <- map["payment_mode"]
        userCart <- map["cart"]
    }
}

class ProfileCartModel: Mappable {

    var id : Int?
    var product_id : Int?
    var promocode_id : String?
    var order_id : String?
    var quantity : Int?
    var note : String?
    var savedforlater : Int?
    var CartProduct : CartProductModel?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        product_id <- map["product_id"]
        promocode_id <- map["promocode_id"]
        order_id <- map["order_id"]
        quantity <- map["quantity"]
        note <- map["note"]
        savedforlater <- map["savedforlater"]
        CartProduct <- map["product"]
        
    }
}
class CartProductModel: Mappable {
    
    var id : Int?
    var shop_id : Int?
    var name : String?
    var description : String?
    var position : Int?
    var food_type : String?
    var avalability : Int?
    var max_quantity : Int?
    var featured : Int?
    var addon_status : Int?
    var out_of_stock : String?
    var status : String?
    var cartItemPrice : CartpriceModel?
    var categoriesProductsImages : [CategoriesProductsImages]?
    var shopList : ShopList?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shop_id <- map["shop_id"]
        name <- map["name"]
        description <- map["description"]
        position <- map["position"]
        food_type <- map["food_type"]
        avalability <- map["avalability"]
        max_quantity <- map["max_quantity"]
        featured <- map["featured"]
        addon_status <- map["addon_status"]
        out_of_stock <- map["out_of_stock"]
        status <- map["status"]
        cartItemPrice <- map["prices"]
        categoriesProductsImages <- map["images"]
        shopList <- map["shop"]
    }
}
class CartpriceModel: Mappable {
    
    var id : Int?
    var price : Int?
    var orignal_price : Int?
    var currency : String?
    var discount : Int?
    var discount_type : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        price <- map["price"]
        orignal_price <- map["orignal_price"]
        currency <- map["currency"]
        discount <- map["discount"]
        discount_type <- map["discount_type"]
        
    }
}
class ShopList: Mappable {

    var id : Int?
    var name : String?
    var email : String?
    var phone : String?
    var avatar : String?
    var default_banner : String?
    var description : String?
    var offer_min_amount : Int?
    var offer_percent : Int?
    var estimated_delivery_time : Int?
    var otp : Int?
    var address : String?
    var maps_address : String?
    var latitude : Double?
    var longitude : Double?
    var commission : Int?
    var pure_veg : Int?
    var popular : Int?
    var rating : Int?
    var rating_status : Int?
    var status : String?
    var device_type : String?
    var device_token : String?
    var device_id : String?
    var created_at : String?
    var updated_at : String?
    var deleted_at : String?
    var distance : Double?
    var open_close : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        avatar <- map["avatar"]
        default_banner <- map["default_banner"]
        description <- map["description"]
        offer_min_amount <- map["offer_min_amount"]
        offer_percent <- map["offer_percent"]
        estimated_delivery_time <- map["estimated_delivery_time"]
        otp <- map["otp"]
        address <- map["address"]
        maps_address <- map["maps_address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        commission <- map["commission"]
        pure_veg <- map["pure_veg"]
        popular <- map["popular"]
        rating <- map["rating"]
        rating_status <- map["rating_status"]
        status <- map["status"]
        device_type <- map["device_type"]
        device_token <- map["device_token"]
        device_id <- map["device_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        deleted_at <- map["deleted_at"]
        distance <- map["distance"]
        open_close <- map["open_close"]
    }
}
