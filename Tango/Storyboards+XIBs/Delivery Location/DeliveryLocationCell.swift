//
//  DeliveryLocationCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DeliveryLocationCell: UITableViewCell {
    
    static let identifier = "DeliveryLocationCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryLocationCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
