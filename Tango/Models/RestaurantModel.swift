//
//  RestaurantModel.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class RestaurantModel: Mappable {
    
    var shopList : [RestaurantList]?
    var currency : String?
    var nearby_distance : String?
    var far_distance : String?
    var total_shops : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        shopList <- map["shops"]
        currency <- map["currency"]
        nearby_distance <- map["nearby_distance"]
        far_distance <- map["far_distance"]
        total_shops <- map["total_shops"]
    }
}

class RestaurantList: Mappable {

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
    var shopstatus : String?
    var restaurantCuisines : [RestaurantCuisines]?
    var restauranttTimings : [RestauranttTimings]?
    var ratings : Int?
    var restaurantCategories : [RestaurantCategories]?
    
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
        restaurantCuisines <- map["cuisines"]
        restauranttTimings <- map["timings"]
        ratings <- map["ratings"]
        restaurantCategories <- map["categories"]
        shopstatus <- map["shopstatus"]
    }
}
class RestaurantCuisines: Mappable {
    
    var id : Int?
    var name : String?
    var pivotshop_id : Int?
    var pivotcuisine_id : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        pivotshop_id <- map["pivot.shop_id"]
        pivotcuisine_id <- map["pivot.cuisine_id"]
    }
}

class RestauranttTimings: Mappable {
    
    var id : Int?
    var shop_id : Int?
    var start_time : String?
    var end_time : String?
    var day : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shop_id <- map["shop_id"]
        start_time <- map["start_time"]
        end_time <- map["end_time"]
        day <- map["day"]
    }
}

class RestaurantCategories: Mappable {

    var id : Int?
    var parent_id : Int?
    var shop_id : Int?
    var name : String?
    var description : String?
    var position : Int?
    var status : String?
    var categoriesProducts : [CategoriesProducts]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        parent_id <- map["parent_id"]
        shop_id <- map["shop_id"]
        name <- map["name"]
        description <- map["description"]
        position <- map["position"]
        status <- map["status"]
        categoriesProducts <- map["products"]
    }
}
class CategoriesProducts: Mappable {
    
    var id : Int?
    var shop_id : Int?
    var name : String?
    var description : String?
    var position : Int?
    var food_type : String?
    var avalability : Int?
    var max_quantity : String?
    var featured : String?
    var addon_status : String?
    var out_of_stock : String?
    var status : String?
 
    var pricesid : Int?
    var pricesprice : Int?
    var pricesorignal_price : Int?
    var pricescurrency : String?
    var pricesdiscount : Int?
    var pricesdiscount_type : String?
    var categoriesProductsImages : [CategoriesProductsImages]?
    
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
        
        pricesid <- map["prices.id"]
        pricesprice <- map["prices.price"]
        pricesorignal_price <- map["prices.orignal_price"]
        pricescurrency <- map["prices.currency"]
        pricesdiscount <- map["prices.discount"]
        pricesdiscount_type <- map["prices.discount_type"]
        categoriesProductsImages <- map["images"]
    }
}


class CategoriesProductsImages: Mappable {
    
    
    var url : String?
    var position : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        position <- map["position"]
        
    }
}
