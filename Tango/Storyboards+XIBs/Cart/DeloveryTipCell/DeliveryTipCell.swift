//
//  DeliveryTipCell.swift
//  Tango
//
//  Created by Samir Samanta on 30/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol updatetipsvalue {
    func tipsValue(value : String)
}
class DeliveryTipCell: UITableViewCell {
    @IBOutlet weak var tipCollectionView: UICollectionView!
    var priceArray = NSArray()
    var amountArray = [TipModel]()
    var delegate : updatetipsvalue?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tipCollectionView.register(UINib(nibName: "TipCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TipCollectionViewCell")
        
        self.tipCollectionView.delegate = self
        self.tipCollectionView.dataSource = self
        priceArray = ["₹10", "₹15", "₹20" , "₹25" , "Other"]
        let value = TipModel()
        value.amount = "10"
        value.isSelect = false
        amountArray.append(value)
        
        let value4 = TipModel()
        value4.amount = "15"
        value4.isSelect = false
        amountArray.append(value4)
        
        let value2 = TipModel()
        value2.amount = "20"
        value2.isSelect = false
        amountArray.append(value2)
        
        let value3 = TipModel()
        value3.amount = "25"
        value3.isSelect = false
        amountArray.append(value3)
        
        let value5 = TipModel()
        value5.amount = "Other"
        value5.isSelect = false
        amountArray.append(value5)
        
        self.tipCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension DeliveryTipCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        return amountArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipCollectionViewCell", for: indexPath as IndexPath) as! TipCollectionViewCell
        
//        if indexPath.row == 4 {
//            if
//            cell.lblAmount.text = "₹\(amountArray[indexPath.row].amount ?? "")"
//        }else{
//            cell.lblAmount.text = "₹\(amountArray[indexPath.row].amount ?? "")"
//        }
        
        cell.lblAmount.text = "₹\(amountArray[indexPath.row].amount ?? "")"
        if amountArray[indexPath.row].isSelect == true {
            cell.lblAmount.textColor = UIColor(red:255/255, green:152/255, blue:0/255, alpha: 1)
            cell.AmountView.layer.borderWidth = 0.5
            cell.AmountView.layer.borderColor = UIColor(red:255/255, green:152/255, blue:0/255, alpha: 1).cgColor
            cell.imgCros.isHidden = false
        }else{
            cell.AmountView.layer.borderWidth = 0.5
            cell.AmountView.layer.borderColor = UIColor(red:154/255, green:154/255, blue:154/255, alpha: 1).cgColor
            cell.lblAmount.textColor = .black
            cell.imgCros.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width : CGFloat = 350
//        let height: CGFloat = 200
        
        let width : CGFloat = (collectionView.frame.width - (20 + 10))/3 //150
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if amountArray[indexPath.row].isSelect == true {
            for obj in amountArray {
                obj.isSelect = false
            }
            amountArray[indexPath.row].isSelect = false
            
            delegate?.tipsValue(value: "0")
        }else{
            for obj in amountArray {
                obj.isSelect = false
            }
            delegate?.tipsValue(value: amountArray[indexPath.row].amount!)
            amountArray[indexPath.row].isSelect = true
        }
        tipCollectionView.reloadData()
        
    }
}
