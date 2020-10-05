//
//  CartDetailsCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol promocodeDelegates {
    func promocodeApply()
}
class CartDetailsCell: UITableViewCell {
    
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var viewPromobtn: UIView!
    @IBOutlet weak var lblPromoAmount: UILabel!
    @IBOutlet weak var lblPackagingFee: UILabel!
    @IBOutlet weak var lblDeliveryTip: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblServiceTax: UILabel!
    @IBOutlet weak var lblDiscountAmount: UILabel!
    @IBOutlet weak var lblGrantTotal: UILabel!
    var promocodeDelegate : promocodeDelegates?
    static let identifier = "CartDetailsCell"
    static func nib() -> UINib{
        return UINib(nibName: "CartDetailsCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func userPromoCodeBtnAction(_ sender: Any) {
        promocodeDelegate?.promocodeApply()
    }
    
    func initializeCellDetails(cellDic : UserCartModel , orderDetails : OrderSaveModel){
        if orderDetails.wallet == 0 {
            viewPromobtn.backgroundColor = UIColor.init(red: 16/255, green: 70/255, blue: 185/255, alpha: 1)
            btnApplyPromoCode.setTitle("APPLY PROMO CODE", for: .normal)
        }else{
            viewPromobtn.backgroundColor = UIColor.init(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
            btnApplyPromoCode.setTitle("REMOVE PROMO CODE", for: .normal)
        }
        
        lblPromoAmount.text = "₹\(orderDetails.wallet)"
        lblDeliveryTip.text = "₹\(orderDetails.tips_amount)"
        let tipsAmount = Int(orderDetails.tips_amount)
        var totalItemTaxAmount = 0
       if let deliveryFee = cellDic.delivery_charges {
            lblDeliveryFee.text = "₹\(deliveryFee)"
        totalItemTaxAmount += Int(deliveryFee)!
       }else{
            lblDeliveryFee.text = "0"
        }
        if let packaging_charge = cellDic.packaging_charge {
         totalItemTaxAmount += Int(packaging_charge)!
            lblPackagingFee.text = "₹\(packaging_charge)"
        }
        
        var totalItemAmount = 0
        for obj in cellDic.userCart! {
            totalItemAmount += ((obj.CartProduct?.cartItemPrice!.price)! * obj.quantity!)
        }
        lblAmount.text = "₹\(totalItemAmount)"
        
        totalItemTaxAmount += totalItemAmount
        let taxPercentage = Double(cellDic.tax_percentage!)
        let serviceTax = calculatePercentage(value: Double(totalItemAmount) ,percentageVal: taxPercentage!)
        
        totalItemTaxAmount += Int(serviceTax)
        totalItemTaxAmount -= orderDetails.wallet
        totalItemTaxAmount += tipsAmount!
        lblServiceTax.text = "₹\(serviceTax)"
        lblGrantTotal.text = "₹\(totalItemTaxAmount)"
        orderDetails.totalAmount = totalItemTaxAmount
    }
    
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
}
