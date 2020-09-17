//
//  OrderDetailsModel.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class OrderDetailsModel: Mappable {

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
        shopList <- map["shop"]
        userCart <- map["items"]
        orderStatusList <- map["ordertiming"]
    }
}

class OrderInvoice: Mappable {
    
    var id : Int?
    var order_id : Int?
    var quantity : Int?
    var paid : Int?
    var gross : Int?
    var discount : Int?
    var delivery_charge : Int?
    var tips_amount : Int?
    var packaging_charge : Int?
    var commission : Double?
    var rider_commission : Int?
    var delivery_distance : Int?
    var wallet_amount : Int?
    var payable : Int?
    var tax : Int?
    var net : Int?
    var total_pay : Int?
    var tender_pay : Int?
    var ripple_price : String?
    var payment_mode : String?
    var DestinationTag : String?
    var payment_id : String?
    var status : String?
    var created_at : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        order_id <- map["order_id"]
        quantity <- map["quantity"]
        paid <- map["paid"]
        gross <- map["gross"]
        discount <- map["discount"]
        
        delivery_charge <- map["delivery_charge"]
        tips_amount <- map["tips_amount"]
        packaging_charge <- map["packaging_charge"]
        commission <- map["commission"]
        rider_commission <- map["rider_commission"]
        delivery_distance <- map["delivery_distance"]
        wallet_amount <- map["wallet_amount"]
        payable <- map["payable"]
        
        tax <- map["tax"]
        net <- map["net"]
        total_pay <- map["total_pay"]
        tender_pay <- map["tender_pay"]
        ripple_price <- map["ripple_price"]
        payment_mode <- map["payment_mode"]
        DestinationTag <- map["DestinationTag"]
        payment_id <- map["payment_id"]
        
        status <- map["status"]
        created_at <- map["created_at"]
    }
}
class OrderStatusList: Mappable {

    var id : Int?
    var order_id : Int?
    var status : String?
    var created_at : String?
    var updated_at : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        order_id <- map["order_id"]
        status <- map["status"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}
