//
//  DashboradPromocodeCell.swift
//  Tango
//
//  Created by Samir Samanta on 01/10/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class DashboradPromocodeCell: UITableViewCell {

    @IBOutlet weak var promoCodeCollectionView: UICollectionView!
    var promoList = [PromoCodeModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.promoCodeCollectionView.register(UINib(nibName: "PromoCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PromoCollectionCell")

        self.promoCodeCollectionView.delegate = self
        self.promoCodeCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initializeCellDetails(cellDic : [PromoCodeModel]){
        promoList = cellDic
        promoCodeCollectionView.reloadData()
    }
}

extension DashboradPromocodeCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if promoList != nil && promoList.count > 0 {
            return promoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromoCollectionCell", for: indexPath as IndexPath) as! PromoCollectionCell
       
        cell.lblPromoCodeName.text = promoList[indexPath.row].promo_code!
        let dateForm = convertDateFormater(promoList[indexPath.row].avail_from!)
        let dateTo = convertDateFormater(promoList[indexPath.row].expiration!)
        cell.lblValid.text = "\(dateForm) - \(dateTo)"
        if promoList[indexPath.row].promocode_type == "percent" {
            cell.lbloffValue.text = "\(promoList[indexPath.row].discount ?? 0) % OFF"
        }else{
            cell.lbloffValue.text = "\(promoList[indexPath.row].discount ?? 0) OFF"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 160
        let height: CGFloat = 140
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //delegateSft?.navigateToSafetyDetails(id: safetyBanner[indexPath.row].id!)
    }
    
    func convertDateFormater(_ date: String) -> String
    {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM"
        return  dateFormatter.string(from: date!)
    }
}
