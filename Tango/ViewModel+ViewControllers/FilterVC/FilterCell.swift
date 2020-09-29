//
//  FilterCell.swift
//  Tango
//
//  Created by Samir Samanta on 28/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet weak var radioCheck: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
