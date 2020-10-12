//
//  SliderCollectionViewCell.swift
//  Tango
//
//  Created by Samir Samanta on 20/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var offerView: RoundUIView!
    @IBOutlet weak var imgSlider: UIImageView!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
