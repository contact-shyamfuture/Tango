//
//  SliderCell.swift
//  Tango
//
//  Created by Samir Samanta on 20/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {

    @IBOutlet weak var sliderCollection: UICollectionView!
    var topBanner = [TopBannerModel]()
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
    func initializeCellDetails(cellDic : [TopBannerModel]){
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
        cell.imgSlider.sd_setImage(with: URL(string: topBanner[indexPath.row].url!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 270
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
}