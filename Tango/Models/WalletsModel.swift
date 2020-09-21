//
//  WalletsModel.swift
//  Tango
//
//  Created by Samir Samanta on 18/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class WalletsModel: Mappable {
    
    var id : Int?
    var user_id : Int?
    var amount : String?
    var message : String?
    var status : String?
    var created_at : String?
    var deleted_at : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        amount <- map["amount"]
        message <- map["message"]
        status <- map["status"]
        created_at <- map["created_at"]
        deleted_at <- map["deleted_at"]
    }
}
