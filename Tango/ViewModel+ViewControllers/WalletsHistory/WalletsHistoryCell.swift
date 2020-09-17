//
//  WalletsHistoryCell.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class WalletsHistoryCell: UITableViewCell {
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblAmountType: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
