//
//  TabBarView.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 08/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    
    @IBOutlet weak var tabCollection: UICollectionView!
    @IBOutlet weak var menuHomeImg: UIImageView!
    @IBOutlet weak var menuContactImg: UIImageView!
    @IBOutlet weak var menuActivityImg: UIImageView!
    @IBOutlet weak var menuApplyImg: UIImageView!
    @IBOutlet weak var menuProfileImg: UIImageView!

    @IBOutlet var tabBarView: UIView!
    
    @IBOutlet weak var lblMe: UILabel!
    @IBOutlet weak var lblApply: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var lblContacts: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    var onClickHomeButtonAction: (() -> Void)? = nil
    var onClickSearchtButtonAction: (() -> Void)? = nil
    var onClickCartButtonAction: (() -> Void)? = nil
    var onClickProfileButtonAction: (() -> Void)? = nil

    var nameArray = NSArray()
    var imgArray = NSArray()
    var uiColorArray = [UIColor]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit(){
        nameArray = ["Home","Search","Cart","Profile"]
        
        Bundle.main.loadNibNamed("TabBarView", owner: self, options: nil)
        addSubview(tabBarView)
        tabBarView.frame = self.bounds
        tabBarView.autoresizingMask = .flexibleHeight
        imgArray = ["Home","Search","finished","Profile"]
        uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        self.tabCollection.register(UINib(nibName: "TabCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TabCollectionCell")
        tabCollection.delegate = self
        tabCollection.dataSource = self
    }
    
    
    @IBAction func btnHomeAction(_ sender: Any) {
        if self.onClickHomeButtonAction != nil{
            self.onClickHomeButtonAction!()
        }
    }
    
    @IBAction func btnContactAction(_ sender: Any) {
        
    }
    
    @IBAction func btnMonitorAction(_ sender: Any) {
        
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        if self.onClickProfileButtonAction != nil{
            self.onClickProfileButtonAction!()
        }
    }
}

extension TabBarView : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionCell", for: indexPath as IndexPath) as! TabCollectionCell
        cell.lblMenuName.text = (nameArray[indexPath.row] as! String)
        cell.menuImgView.image = UIImage(named: imgArray[indexPath.row] as! String)
        cell.lblMenuName.textColor = uiColorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (5 + 10))/4 //150
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            if self.onClickHomeButtonAction != nil{
                self.onClickHomeButtonAction!()
            }
        case 1:
            if self.onClickSearchtButtonAction != nil{
                self.onClickSearchtButtonAction!()
            }
        case 2:
            if self.onClickCartButtonAction != nil{
                self.onClickCartButtonAction!()
            }
        case 3:
            if self.onClickProfileButtonAction != nil{
                self.onClickProfileButtonAction!()
            }

        default:
            break
        }
    }
}
