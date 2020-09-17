//
//  DishesCell.swift
//  Tango
//
//  Created by Samir Samanta on 07/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DishesCell: UITableViewCell {
    @IBOutlet weak var lblRestaurantName: UILabel!
    
    @IBOutlet weak var btnAddOutlet: UIButton!
    @IBOutlet weak var imgDisheshType: UIImageView!
    @IBOutlet weak var lblDisheshPrice: UILabel!
    @IBOutlet weak var lblDishesName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnAddAction(_ sender: Any) {
        
    }
    
    func initializeCellDetails(cellDic : SearchProductList){
        lblDishesName.text = cellDic.name
        lblDisheshPrice.text = "\(cellDic.cartItemPrice!.currency ?? "") \(cellDic.cartItemPrice!.price ?? 00)"
        lblRestaurantName.text = cellDic.shopList?.name
    }
}
