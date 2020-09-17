//
//  File.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class AddressListModel: Mappable {
    var id,user_id : Int?
    var city,building,street,state,country,pincode,landmark,map_address,type : String?
    var latitude,longitude : Double?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        city <- map["city"]
        building <- map["building"]
        state <- map["state"]
        country <- map["country"]
        pincode <- map["pincode"]
        landmark <- map["landmark"]
        map_address <- map["map_address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        type <- map["type"]
    }
}

//Address Save Model

class AddressSaveModel: Mappable {

    var message : String?
    var type : [String]?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        type <- map["type"]
    }
}

class AddressSaveParamModel: Mappable {

    var building : String?
    var city : String?
    var country : String?
    var landmark : String?
    var pincode : String?
    var state : String?
    var type : String?
    var latitude : Double?
    var longitude : Double?
    var map_address : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        building <- map["building"]
        city <- map["city"]
        country <- map["country"]
        landmark <- map["landmark"]
        pincode <- map["pincode"]
        state <- map["state"]
        type <- map["type"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        map_address <- map["map_address"]
    }
}
