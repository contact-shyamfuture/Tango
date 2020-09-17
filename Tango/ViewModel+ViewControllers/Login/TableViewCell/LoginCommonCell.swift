//
//  LoginCommonCell.swift
//  Tango
//
//  Created by Samir Samanta on 05/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class LoginCommonCell: UITableViewCell {
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var codeConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
