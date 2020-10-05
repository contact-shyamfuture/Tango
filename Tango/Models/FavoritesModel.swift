//
//  FavoritesModel.swift
//  Tango
//
//  Created by Samir Samanta on 03/10/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FavoritesModel: Mappable {

    var favoritesList : [FavoritesList]?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        favoritesList <- map["available"]
    }
}

class FavoritesList: Mappable {
    
    var id : Int?
    var shop_id : Int?
    var user_id : Int?
    var shopList : ShopList?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        shop_id <- map["shop_id"]
        user_id <- map["user_id"]
        shopList <- map["shop"]
    }
}

class FavoritesAdd: Mappable {
    
    var message : String?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]

    }
}
class LocationCheck: Mappable {
    

    var proceed : String?
    var msg : String?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        proceed <- map["proceed"]
        msg <- map["msg"]

    }
}
