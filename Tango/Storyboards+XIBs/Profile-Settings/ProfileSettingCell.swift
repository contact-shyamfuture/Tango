//
//  ProfileSettingCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 18/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ProfileSettingCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var imgVw : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!

    
    static let identifier = "ProfileSettingCell"
    static func nib() -> UINib{
        return UINib(nibName: "ProfileSettingCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
