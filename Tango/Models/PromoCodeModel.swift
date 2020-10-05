//
//  PromoCodeModel.swift
//  Tango
//
//  Created by Samir Samanta on 30/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class PromoCodeModel: Mappable {

    var id : Int?
    var promo_code : String?
    var promocode_type : String?
    var discount : Int?
    var coupon_limit : Int?
    var coupon_user_limit : Int?
    var highest_discount : Int?
    var avail_from : String?
    var expiration : String?
    var status : String?
    

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        promo_code <- map["promo_code"]
        promocode_type <- map["promocode_type"]
        discount <- map["discount"]
        coupon_limit <- map["coupon_limit"]
        coupon_user_limit <- map["coupon_user_limit"]
        highest_discount <- map["highest_discount"]
        avail_from <- map["avail_from"]
        expiration <- map["expiration"]
        status <- map["status"]
    }
}
