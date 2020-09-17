//
//  TopBannerModel.swift
//  Tango
//
//  Created by Samir Samanta on 09/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class TopBannerModel: Mappable {

    var id : Int?
    var product_id : Int?
    var url : String?
    var position : Int?
    var status : String?
    var shopList : ShopList?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        product_id <- map["product_id"]
        url <- map["url"]
        position <- map["position"]
        status <- map["status"]
        shopList <- map["shop"]
    }
}
