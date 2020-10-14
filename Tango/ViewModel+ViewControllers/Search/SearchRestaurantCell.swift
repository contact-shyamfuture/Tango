//
//  SearchRestaurantCell.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import HCSStarRatingView
class SearchRestaurantCell: UITableViewCell {
    
    @IBOutlet weak var percentaageImg: UIImageView!
    @IBOutlet weak var closedView: RoundUIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var lblPercentageOffer: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var btnDistance: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellDic : SearchShopList){
        lblName.text = cellDic.name
        imgRestaurant.sd_setImage(with: URL(string: cellDic.avatar!))
        
        lblDetails.text = cellDic.description
        ratingView.value = CGFloat(cellDic.rating ?? 0)
        btnDistance.setTitle("\(cellDic.estimated_delivery_time ?? 0) mint", for: .normal)
        
        if cellDic.shopstatus == "OPEN" {
            closedView.isHidden = true
           // btnDeliveryCharge.isHidden = true
        }else{
            closedView.isHidden = false
            //btnDeliveryCharge.isHidden = true
        }
        
        if cellDic.offer_percent == 0 {
            percentaageImg.isHidden = true
            lblPercentageOffer.text = ""
        }else{
            percentaageImg.isHidden = false
            lblPercentageOffer.text = "Flat \(cellDic.offer_percent ?? 0) % offer on all order"
        }
    }
}
