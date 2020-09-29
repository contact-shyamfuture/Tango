//
//  CartAddressCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol addressSelectionDelegate {
    func selectAddress()
    func addAddress()
    func orderContinue()
}
class CartAddressCell: UITableViewCell {
    
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnCOntiniueAction: UIView!
    static let identifier = "CartAddressCell"
    static func nib() -> UINib{
        return UINib(nibName: "CartAddressCell", bundle: nil)
    }
    var delegate : addressSelectionDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func addAddressBtnAction(_ sender: Any) {
        delegate?.addAddress()
    }
    
    @IBAction func btnSelectAddress(_ sender: Any) {
        delegate?.selectAddress()
    }    
    @IBAction func continueBtnAction(_ sender: Any) {
        delegate?.orderContinue()
    }
}
