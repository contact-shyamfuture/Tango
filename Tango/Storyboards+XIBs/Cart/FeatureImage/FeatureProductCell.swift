//
//  FeatureProductCell.swift
//  Tango
//
//  Created by Samir Samanta on 05/10/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol UserFeatureCartProtocol {
    func userAddToCart(cell : FeatureProductCell)
    func userAddToCartPlus(cell : FeatureProductCell)
    func userAddToCartMinus(cell : FeatureProductCell)
}

class FeatureProductCell: UITableViewCell {
    
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var lblpriceTwo: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var foodType: UIImageView!
    @IBOutlet weak var imgFeature: UIImageView!
    @IBOutlet weak var addView: RoundUIView!
    var delegate : UserFeatureCartProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellDic : RestaurantFeaturedProduct , cartDetails : ProfiledetailsModel){
        lblPrice.text = "\(cellDic.currency ?? "") \(cellDic.orignal_price ?? 0)"
        lblpriceTwo.text = ""
        lblFoodName.text = cellDic.name
        if cellDic.food_type == "veg" {
            foodType.image = UIImage(named: "vegFoodIcon")
        }else{
            foodType.image = UIImage(named: "nonVegFoodIcon")
        }
        if cellDic.featureImag != nil && cellDic.featureImag!.count > 0 {
            imgFeature.sd_setImage(with: URL(string: cellDic.featureImag![0].url ?? ""))
        }
        
        addView.isHidden = false
        if let cartList = cartDetails.userCart {
            for obj in cartList {
                if cellDic.id == obj.product_id {
                    addView.isHidden = true
                    lblCartCount.text = "\(obj.quantity ?? 0)"
                    break
                }
            }
        }
    }
    
    @IBAction func cartMinusBtnAction(_ sender: Any) {
        delegate?.userAddToCartMinus(cell: self)
    }
    
    @IBAction func cartPlusBtnAction(_ sender: Any) {
        delegate?.userAddToCartPlus(cell: self)
    }
    
    @IBAction func cartAddBtnAction(_ sender: Any) {
        delegate?.userAddToCart(cell: self)
    }
    
}
