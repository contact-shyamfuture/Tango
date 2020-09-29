//
//  OrderListModel.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class OrderListModel: Mappable {

    var id : Int?
    var invoice_id : String?
    var user_id : Int?
    var shift_id : Int?
    var user_address_id : Int?
    var shop_id : Int?
    var transporter_id : Int?
    var transporter_vehicle_id : Int?
    var reason : String?
    var note : String?
    var route_key : String?

    var dispute : String?
    var delivery_date : String?
    var order_otp : Int?
    var order_ready_time : Int?
    var order_ready_status : Int?
    var status : String?
    var created_at : String?
    var schedule_status : Int?
    var userDetails : ProfiledetailsModel?

    var transporter : String?
    var vehicles : String?

    var invoiceDetails : OrderInvoice?
    var address : OrderAddress?
    var shopList : ShopList?

    var userCart : [ProfileCartModel]?
    var orderStatusList : [OrderStatusList]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        invoice_id <- map["invoice_id"]
        user_id <- map["user_id"]
        shift_id <- map["shift_id"]
        user_address_id <- map["user_address_id"]
        shop_id <- map["shop_id"]

        transporter_id <- map["transporter_id"]
        transporter_vehicle_id <- map["transporter_vehicle_id"]
        reason <- map["reason"]
        note <- map["note"]
        route_key <- map["route_key"]
        userDetails <- map["user"]

        transporter <- map["transporter"]
        vehicles <- map["vehicles"]
        invoiceDetails <- map["invoice"]
        address <- map["address"]
        shopList <- map["shop"]
        userCart <- map["items"]
        orderStatusList <- map["ordertiming"]
        
        
        dispute <- map["dispute"]
        delivery_date <- map["delivery_date"]
        order_otp <- map["order_otp"]
        order_ready_time <- map["order_ready_time"]
        order_ready_status <- map["order_ready_status"]
        status <- map["status"]
        created_at <- map["created_at"]
    }
}
