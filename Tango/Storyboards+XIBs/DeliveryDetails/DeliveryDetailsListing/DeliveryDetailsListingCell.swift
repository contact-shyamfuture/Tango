//
//  DeliveryDetailsListingCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 17/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import SDWebImage

class DeliveryDetailsListingCell: UITableViewCell {

    @IBOutlet weak var imgVwItems: UIImageView!
    @IBOutlet weak var imgVwSymbol: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQuantity: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    
    static let identifier = "DeliveryDetailsListingCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryDetailsListingCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func cellConfigUI(with model : ProfileCartModel){
        guard let images = model.CartProduct?.categoriesProductsImages else {return}
        if images.count > 0{
            self.imgVwItems.sd_setImage(with: URL(string: images[0].url ?? ""), placeholderImage: UIImage(named: ""))
        }
        lblItemName.text = model.CartProduct?.name ?? ""
        lblItemQuantity.text = "\(model.quantity ?? 0)"
        lblItemPrice.text = "\(model.CartProduct?.cartItemPrice?.currency ?? "")\(model.CartProduct?.cartItemPrice?.price ?? 0)"
        
    }
    
}
