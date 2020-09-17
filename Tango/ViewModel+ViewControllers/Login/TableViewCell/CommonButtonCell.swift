//
//  CommonButtonCell.swift
//  Tango
//
//  Created by Samir Samanta on 05/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol CommonButtonAction {
    func loginRegisttration()
}
class CommonButtonCell: UITableViewCell {

    @IBOutlet weak var btnCommonOutlet: UIButton!
    var delegate : CommonButtonAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonLoginAction(_ sender: Any) {
        delegate?.loginRegisttration()
    }
}
