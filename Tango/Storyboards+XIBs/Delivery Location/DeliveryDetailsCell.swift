//
//  DeliveryDetailsCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DeliveryDetailsCell: UITableViewCell {

    @IBOutlet weak var txtVwAddress: UITextView!
    @IBOutlet weak var txtFldHouseNo: UITextField!
    @IBOutlet weak var txtFldlandmark: UITextField!
    
    static let identifier = "DeliveryDetailsCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryDetailsCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnHomeAction(_ sender: UIButton) {
    }
    @IBAction func btnOfficeAction(_ sender: UIButton) {
    }
    @IBAction func btnOtherAction(_ sender: UIButton) {
    }
    
    
}

