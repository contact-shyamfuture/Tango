//
//  OrderSaveModel.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class OrderSaveModel: NSObject {

    var note = String()
    var payment_mode = String()
    var wallet = Int()
    var delivery_charge = String()
    var packaging_charge = String()
    var user_address_id : Int?
    var user_address = String()
    var addressType = String()
    var tips_amount = "0"
    var tips_Othe_amount = "0"
    var promoID = Int()
    var totalAmount = Int()
}
