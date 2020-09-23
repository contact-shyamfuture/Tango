//
//  AddressListCell.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol manageAddress {
    func manageAddressDelete(index : Int)
    func manageAddressEdit(index : Int)
}
class AddressListCell: UITableViewCell {

    @IBOutlet weak var editbtnOutlet: UIButton!
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStackVw: UIStackView!
    var delegate : manageAddress?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        delegate?.manageAddressEdit(index: sender.tag)
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        delegate?.manageAddressDelete(index: sender.tag)
    }
}
