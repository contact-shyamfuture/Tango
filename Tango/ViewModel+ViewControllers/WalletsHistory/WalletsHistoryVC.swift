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
    
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var wallet_balance : Int?
    var WalletsDetails = [WalletsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        headerView.btnHeartOutlet.isHidden = true

        self.walletsHistoryTable.register(UINib(nibName: "WallesTopCells", bundle: Bundle.main), forCellReuseIdentifier: "WallesTopCells")
        self.walletsHistoryTable.register(UINib(nibName: "WalletsList", bundle: Bundle.main), forCellReuseIdentifier: "WalletsList")
        self.walletsHistoryTable.register(UINib(nibName: "WalletsHistoryCell", bundle: Bundle.main), forCellReuseIdentifier: "WalletsHistoryCell")
        
        walletsHistoryTable.delegate = self
        walletsHistoryTable.dataSource = self
        getWalletsDetails()
    }
    
    func getWalletsDetails(){
        viewModel.getWalletsAPIService()
    }
    
    func initializeViewModel() {
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.WalletsDetails) != nil {
                    self?.WalletsDetails = (self?.viewModel.WalletsDetails)!
                    self?.walletsHistoryTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}
extension WalletsHistoryVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if WalletsDetails != nil && WalletsDetails.count > 0 {
            return WalletsDetails.count + 3
        }else{
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WallesTopCells") as! WallesTopCells
            Cell.lblTitle.text = "WALLET"
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletsList") as! WalletsList
            Cell.lblAmount.text = "\(wallet_balance ?? 0)"
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WallesTopCells") as! WallesTopCells
            Cell.lblTitle.text = "HISTORY"
            return Cell
        case 3...WalletsDetails.count + 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletsHistoryCell") as! WalletsHistoryCell
            Cell.initializeCellDetails(cell: WalletsDetails[indexPath.row - 3])
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
