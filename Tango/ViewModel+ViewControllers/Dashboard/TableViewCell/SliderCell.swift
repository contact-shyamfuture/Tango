//
//  SliderCell.swift
//  Tango
//
//  Created by Samir Samanta on 20/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol topPicForYouDelegate {
    func topPic(index : Int)
}
class SliderCell: UITableViewCell {

    @IBOutlet weak var sliderCollection: UICollectionView!
   // var topBanner = [TopBannerModel]()
    
    var topBanner = [RestaurantList]()
    var topDele : topPicForYouDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sliderCollection.register(UINib(nibName: "SliderCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        self.sliderCollection.delegate = self
        self.sliderCollection.dataSource = self
        self.sliderCollection.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func initializeCellDetails(cellDic : [RestaurantList]){
        topBanner = cellDic
        sliderCollection.reloadData()
    }
}

extension SliderCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        if topBanner != nil && topBanner.count > 0 {
            return topBanner.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath as IndexPath) as! SliderCollectionViewCell
        cell.imgSlider.sd_setImage(with: URL(string: topBanner[indexPath.row].avatar!))
        if topBanner[indexPath.row].offer_percent == 0 {
            cell.offerView.isHidden = true
            cell.lblOffer.text = ""
        }else{
            cell.offerView.isHidden = false
            cell.lblOffer.text = "\(topBanner[indexPath.row].offer_percent ?? 0)  % OFF"
        }
        cell.lblName.text = "\(topBanner[indexPath.row].name ?? "")"
        
        if topBanner[indexPath.row].shopstatus == "OPEN" {
            cell.closedView.isHidden = true
        }else{
            cell.closedView.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 220
        let height: CGFloat = 170
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
        topDele?.topPic(index: indexPath.row)
    }
}
