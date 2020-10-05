//
//  MenuDetailsVC.swift
//  Tango
//
//  Created by Samir Samanta on 24/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class MenuDetailsVC: BaseViewController {

    @IBOutlet weak var tableMenuDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.btnHeartOutlet.isHidden = true

        self.tabBarView.imgArray = ["HomeSelected","Search","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        
    }
}
