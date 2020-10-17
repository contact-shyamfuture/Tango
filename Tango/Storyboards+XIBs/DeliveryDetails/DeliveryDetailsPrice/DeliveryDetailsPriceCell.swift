//
//  DeliveryDetailsPriceCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 17/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DeliveryDetailsPriceCell: UITableViewCell {

    @IBOutlet weak var lblDeliveryTips: UILabel!
    @IBOutlet weak var lblPackagingCharges: UILabel!
    @IBOutlet weak var lblItemTotalPrice: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    
    static let identifier = "DeliveryDetailsPriceCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryDetailsPriceCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfigUI(with model : OrderInvoice , itemData : [ProfileCartModel]){
        var totalItemAmount = 0
        for obj in itemData {
            totalItemAmount += ((obj.CartProduct?.cartItemPrice!.price)! * obj.quantity!)
        }
        lblItemTotalPrice.text = "₹\(totalItemAmount)"
        lblDeliveryFee.text = "₹\(model.delivery_charge ?? 0)"
        lblServiceCharge.text = "₹\(model.tax ?? 0)"
        lblDiscount.text = "₹\(model.discount ?? 0)"
        lblTotalPrice.text = "₹\(model.payable ?? 0)"
        
        lblDeliveryTips.text = "₹\(model.tips_amount ?? 0)"
        lblPackagingCharges.text = "₹\(model.packaging_charge ?? 0)"
        
    }
}
