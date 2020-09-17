//
//  PaymentViewCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol selectPaymentOption {
    func selectOption(index : Int)
}

class PaymentViewCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    var delegate : selectPaymentOption?
    static let identifier = "PaymentViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "PaymentViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSelectOption(_ sender: Any) {
        delegate?.selectOption(index: (sender as AnyObject).tag)
    }
}
