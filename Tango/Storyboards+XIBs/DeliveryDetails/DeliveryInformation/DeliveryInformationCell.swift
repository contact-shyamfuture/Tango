//
//  DeliveryInformationCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 17/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DeliveryInformationCell: UITableViewCell {
    
    //properties outlet
    @IBOutlet var bottomVw: [UIView]!
    
    var tapBtnClosure : ((String)->())?

    static let identifier = "DeliveryInformationCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryInformationCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomVw[1].isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnOrderDetailsAction(_ sender: Any) {
        bottomVw[0].isHidden = false
        bottomVw[1].isHidden = true
        tapBtnClosure?("OrderDetails")
    }
    @IBAction func btnHelpAction(_ sender: Any) {
        bottomVw[0].isHidden = true
        bottomVw[1].isHidden = false
        tapBtnClosure?("Help")
    }
    
    
}
