//
//  ItemCell.swift
//  Tango
//
//  Created by Samir Samanta on 20/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SDWebImage
class ItemCell: UITableViewCell {

    @IBOutlet weak var closedView: RoundUIView!
    @IBOutlet weak var btnDeliveryCharge: UIButton!
    @IBOutlet weak var btnDistanceTime: UIButton!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var lblMenuNAme: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDesrciptiuon: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initializeCellDetails(cellDic : RestaurantList){
        lblMenuNAme.text = cellDic.name
        lblDesrciptiuon.text = cellDic.description
        lblDiscount.text = "\(cellDic.offer_percent ?? 0) % off"
        ratingView.value = CGFloat(cellDic.rating ?? 0)
        btnDistanceTime.setTitle("\(cellDic.estimated_delivery_time ?? 0) mint", for: .normal)
        menuImage.sd_setImage(with: URL(string: cellDic.avatar!))
        if cellDic.shopstatus == "OPEN" {
            closedView.isHidden = true
            btnDeliveryCharge.isHidden = true
        }else{
            closedView.isHidden = false
            btnDeliveryCharge.isHidden = true
        }
    }
    func initializeCellNearDetails(cellDic : RestaurantList){
        lblMenuNAme.text = cellDic.name
        lblDesrciptiuon.text = cellDic.description
        lblDiscount.text = "\(cellDic.offer_percent ?? 0) % off"
        ratingView.value = CGFloat(cellDic.rating ?? 0)
        btnDistanceTime.setTitle("\(cellDic.estimated_delivery_time ?? 0) mint", for: .normal)
        menuImage.sd_setImage(with: URL(string: cellDic.avatar!))
        if cellDic.shopstatus == "OPEN" {
            closedView.isHidden = true
            btnDeliveryCharge.isHidden = true
        }else{
            closedView.isHidden = false
            btnDeliveryCharge.isHidden = true
        }
    }
}
