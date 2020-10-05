//
//  DishesCell.swift
//  Tango
//
//  Created by Samir Samanta on 07/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol UserDushCartProtocol {
    func userAddToCart(cell : DishesCell)
    func userAddToCartPlus(cell : DishesCell)
    func userAddToCartMinus(cell : DishesCell)
}
class DishesCell: UITableViewCell {
    @IBOutlet weak var lblRestaurantName: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var plusMinusView: UIStackView!
    @IBOutlet weak var addView: RoundUIView!
    @IBOutlet weak var btnAddOutlet: UIButton!
    @IBOutlet weak var imgDisheshType: UIImageView!
    @IBOutlet weak var lblDisheshPrice: UILabel!
    @IBOutlet weak var lblDishesName: UILabel!
    var delegate : UserDushCartProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cartMinusAction(_ sender: Any) {
        delegate?.userAddToCartMinus(cell: self)
    }
    
    @IBAction func cartPlusAction(_ sender: Any) {
        delegate?.userAddToCartPlus(cell: self)
    }
    
    @IBAction func btnAddAction(_ sender: Any) {
        delegate?.userAddToCart(cell: self)
    }
    
    func initializeCellDetails(cellDic : SearchProductList , cartDetails : ProfiledetailsModel){
        lblDishesName.text = cellDic.name
        lblDisheshPrice.text = "\(cellDic.cartItemPrice!.currency ?? "") \(cellDic.cartItemPrice!.price ?? 00)"
        lblRestaurantName.text = cellDic.shopList?.name
        
        if cellDic.food_type == "veg" {
            imgDisheshType.image = UIImage(named: "vegFoodIcon")
        }else{
            imgDisheshType.image = UIImage(named: "nonVegFoodIcon")
        }
        addView.isHidden = false
        plusMinusView.isHidden = true
        if let cartList = cartDetails.userCart {
            for obj in cartList {
                if cellDic.id == obj.product_id {
                    addView.isHidden = true
                    plusMinusView.isHidden = false
                    lblQuantity.text = "\(obj.quantity ?? 0)"
                    break
                }
            }
        }
    }
}
