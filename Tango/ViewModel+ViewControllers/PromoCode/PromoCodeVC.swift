//
//  PromoCodeVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol PromoCodeApply {
    func applyPromocodes(value : Int)
}
class PromoCodeVC: BaseViewController {
    @IBOutlet weak var promoCodeTable: UITableView!
    var delegate : PromoCodeApply?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true

        self.promoCodeTable.register(UINib(nibName: "PromoCodeCell", bundle: Bundle.main), forCellReuseIdentifier: "PromoCodeCell")
        
        promoCodeTable.delegate = self
        promoCodeTable.dataSource = self

    }
}

extension PromoCodeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeCell") as! PromoCodeCell
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.applyPromocodes(value: 0)
        navigationController?.popViewController(animated: true)
    }
}
