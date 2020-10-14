//
//  OrderListCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 26/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {

    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblMapAddress: UILabel!
    @IBOutlet weak var vwDisputed: UIView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    static let identifier = "OrderListCell"
    static func nib() -> UINib{
        return UINib(nibName: "OrderListCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnReorderAction(_ sender: UIButton) {
    }
    
    func cellConfigUI(with model : OrderListModel){
        lblShopName.text = model.shopList?.name ?? ""
        lblMapAddress.text = model.shopList?.maps_address ?? ""
        guard let items = model.userCart else {return}
        if items.count > 0{
            lblItemName.text = "\(items[0].CartProduct?.name ?? "")(\(items[0].quantity ?? 0))"
        }
        lblOrderDate.text = getFormattedDate(string: model.created_at ?? "")
        lblTotalAmount.text = "₹\(model.invoiceDetails?.payable ?? 0)"
        if model.dispute == "NODISPUTE" {
            vwDisputed.isHidden = true
        }else{
            vwDisputed.isHidden = false
        }
    }
    
    func cellConfigCompletedUI(with model : OrderListModel){
        lblShopName.text = model.shopList?.name ?? ""
        lblMapAddress.text = model.shopList?.maps_address ?? ""
        guard let items = model.userCart else {return}
        if items.count > 0{
            lblItemName.text = "\(items[0].CartProduct?.name ?? "")(\(items[0].quantity ?? 0))"
        }
        lblOrderDate.text = getFormattedDate(string: model.created_at ?? "")
        lblTotalAmount.text = "₹\(model.invoiceDetails?.payable ?? 0)"
        if model.dispute == "NODISPUTE" {
            vwDisputed.isHidden = true
        }else{
            vwDisputed.isHidden = false
        }
    }
    
    func getFormattedDate(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy hh:mm a"
        
        guard let date = dateFormatterGet.date(from: string) else {return ""}
        return dateFormatterPrint.string(from: date)
    }
}
