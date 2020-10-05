//
//  FavouritesCell.swift
//  Tango
//
//  Created by Samir Samanta on 29/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class FavouritesCell: UITableViewCell {

    @IBOutlet weak var txtViewAddress: UITextView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellDic : FavoritesList){
        lblShopName.text = cellDic.shopList?.name
        txtViewAddress.text = cellDic.shopList?.address
        shopImage.sd_setImage(with: URL(string: cellDic.shopList?.avatar ?? ""))
    }
}
