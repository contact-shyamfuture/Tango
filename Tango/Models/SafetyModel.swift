//
//  SafetyModel.swift
//  Tango
//
//  Created by Samir Samanta on 09/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SafetyModel: Mappable {

    var id : Int?
    var title : String?
    var description : String?
    var status : String?
    var avatar : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        status <- map["status"]
        avatar <- map["avatar"]
    }
}
