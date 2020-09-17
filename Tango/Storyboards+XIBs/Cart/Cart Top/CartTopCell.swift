//
//  CartTopCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class CartTopCell: UITableViewCell {
    
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    static let identifier = "CartTopCell"
    static func nib() -> UINib{
        return UINib(nibName: "CartTopCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initializecellDetails(cellDic : ProfileCartModel){
        
        let url = cellDic.CartProduct?.shopList?.avatar
        imgView.sd_setImage(with: URL(string: url!))
        lblDescription.text = cellDic.CartProduct?.shopList?.description
        lblShopName.text = cellDic.CartProduct?.shopList?.name
    }
}
