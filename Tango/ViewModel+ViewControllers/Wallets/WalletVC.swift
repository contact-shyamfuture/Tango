//
//  WalletVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class WalletVC: BaseViewController {

    @IBOutlet weak var walletsTableView: UITableView!
    var wallet_balance : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true

        // Do any additional setup after loading the view.
        self.walletsTableView.register(UINib(nibName: "WallesTopCells", bundle: Bundle.main), forCellReuseIdentifier: "WallesTopCells")
        self.walletsTableView.register(UINib(nibName: "WalletsList", bundle: Bundle.main), forCellReuseIdentifier: "WalletsList")
        headerView.btnHeartOutlet.isHidden = true
        walletsTableView.delegate = self
        walletsTableView.dataSource = self
    }
}

extension WalletVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WallesTopCells") as! WallesTopCells
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletsList") as! WalletsList
            Cell.lblAmount.text = "\(wallet_balance ?? 0)"
            return Cell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70
        case 1:
            return 66
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "WalletsHistoryVC") as? WalletsHistoryVC
        vc!.wallet_balance = wallet_balance
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
