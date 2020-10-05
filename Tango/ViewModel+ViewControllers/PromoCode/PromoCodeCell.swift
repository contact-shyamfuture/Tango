//
//  PromoCodeCell.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class PromoCodeCell: UITableViewCell {
    @IBOutlet weak var btnApplyOulet: UIButton!
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblAmoutOffer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        
    }
    
    func initializeCellDetaill(cellDic : PromoCodeModel){
        lblCode.text = cellDic.promo_code
    }
}
