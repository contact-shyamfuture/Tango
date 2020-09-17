//
//  AddressListCell.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStackVw: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
    }
}
