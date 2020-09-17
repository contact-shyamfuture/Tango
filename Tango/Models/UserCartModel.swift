//
//  UserCartModel.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserCartModel: Mappable {
    
    var delivery_charges : String?
    var packaging_charge : String?
    var delivery_free_minimum : Int?
    var tax_percentage : String?
    var cancel_policy : String?
    var userCart : [ProfileCartModel]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        delivery_charges <- map["delivery_charges"]
        packaging_charge <- map["packaging_charge"]
        delivery_free_minimum <- map["delivery_free_minimum"]
        tax_percentage <- map["tax_percentage"]
        cancel_policy <- map["cancel_policy"]
        userCart <- map["carts"]
    }
}
