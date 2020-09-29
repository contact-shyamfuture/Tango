//
//  FilterModel.swift
//  Tango
//
//  Created by Samir Samanta on 28/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FilterModel: Mappable {

    var id : Int?
    var name : String?
    var isSelected : Bool?

    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        isSelected = false
    }
}
