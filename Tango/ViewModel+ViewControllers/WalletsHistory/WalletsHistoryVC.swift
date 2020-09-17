//
//  WalletsHistoryVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class WalletsHistoryVC: BaseViewController {

    @IBOutlet weak var walletsHistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true

        self.walletsHistoryTable.register(UINib(nibName: "WallesTopCells", bundle: Bundle.main), forCellReuseIdentifier: "WallesTopCells")
        self.walletsHistoryTable.register(UINib(nibName: "WalletsList", bundle: Bundle.main), forCellReuseIdentifier: "WalletsList")
        self.walletsHistoryTable.register(UINib(nibName: "WalletsHistoryCell", bundle: Bundle.main), forCellReuseIdentifier: "WalletsHistoryCell")
        
        walletsHistoryTable.delegate = self
        walletsHistoryTable.dataSource = self
    }
}
extension WalletsHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WallesTopCells") as! WallesTopCells
            Cell.lblTitle.text = "WALLET"
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletsList") as! WalletsList
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WallesTopCells") as! WallesTopCells
            Cell.lblTitle.text = "HISTORY"
            return Cell
        case 3...11:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletsHistoryCell") as! WalletsHistoryCell
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
        case 2:
            return 70
        case 3...11:
            return 100
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
