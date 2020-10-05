//
//  SafetyCellT.swift
//  Tango
//
//  Created by Samir Samanta on 20/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol safetyDetails {
    func navigateToSafetyDetails(id : Int)
}
class SafetyCellT: UITableViewCell {

    @IBOutlet weak var safetyCollectionView: UICollectionView!
    var safetyBanner = [SafetyModel]()
    var delegateSft : safetyDetails?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.safetyCollectionView.register(UINib(nibName: "SafetyCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SafetyCollectionCell")
        
        self.safetyCollectionView.delegate = self
        self.safetyCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initializeCellDetails(cellDic : [SafetyModel]){
        safetyBanner = cellDic
        safetyCollectionView.reloadData()
    }
}

extension SafetyCellT : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if safetyBanner != nil && safetyBanner.count > 0 {
            return safetyBanner.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SafetyCollectionCell", for: indexPath as IndexPath) as! SafetyCollectionCell
        cell.imgView.sd_setImage(with: URL(string: safetyBanner[indexPath.row].avatar!))
        cell.lblName.text = safetyBanner[indexPath.row].title!
        cell.descriptionView.text = safetyBanner[indexPath.row].description!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 350
        let height: CGFloat = 200
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
        delegateSft?.navigateToSafetyDetails(id: safetyBanner[indexPath.row].id!)
    }
}
