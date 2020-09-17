//
//  SearchModel.swift
//  Tango
//
//  Created by Samir Samanta on 08/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SearchModel: Mappable {

    var shopList : [SearchShopList]?
    var searchProductList : [SearchProductList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
       
        shopList <- map["shops"]
        searchProductList <- map["products"]
    }
}

class SearchShopList: Mappable {

    
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
    var ratings : String?
    
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
        ratings <- map["ratings"]
    }
}
class SearchProductList: Mappable {
   
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
    var shopList : ShopList?
    var cartItemPrice : CartpriceModel?
    
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
        description <- map["description"]
        avalability <- map["avalability"]
        max_quantity <- map["max_quantity"]
        featured <- map["featured"]
        addon_status <- map["addon_status"]
        out_of_stock <- map["out_of_stock"]
        status <- map["status"]
        shopList <- map["shop"]
        cartItemPrice <- map["prices"]
    }
}
