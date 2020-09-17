//
//  DeliveryConfirmationListCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 16/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DeliveryConfirmationListCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    static let identifier = "DeliveryConfirmationListCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryConfirmationListCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
