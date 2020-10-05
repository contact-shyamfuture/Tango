//
//  TipCollectionViewCell.swift
//  Tango
//
//  Created by Samir Samanta on 30/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class TipCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgCros: UIImageView!
    
    @IBOutlet weak var AmountView: RoundUIView!
    @IBOutlet weak var lblAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
 
        imgCros.layer.masksToBounds = false
        imgCros.layer.borderColor = UIColor.white.cgColor
        imgCros.layer.cornerRadius = imgCros.frame.size.width / 2
        imgCros.clipsToBounds = true
    }
}
