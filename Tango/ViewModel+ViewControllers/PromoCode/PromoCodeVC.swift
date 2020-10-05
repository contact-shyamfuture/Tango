//
//  PromoCodeVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol PromoCodeApply {
    func applyPromocodes(value : Int , id : Int)
}
class PromoCodeVC: BaseViewController {
    @IBOutlet weak var promoCodeTable: UITableView!
    var delegate : PromoCodeApply?
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var isCart : Bool = false
    var promoList = [PromoCodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        headerView.btnHeartOutlet.isHidden = true

        self.promoCodeTable.register(UINib(nibName: "PromoCodeCell", bundle: Bundle.main), forCellReuseIdentifier: "PromoCodeCell")
        
        promoCodeTable.delegate = self
        promoCodeTable.dataSource = self
        initializeViewModel()
        getPromoDetails()

    }
    
    func getPromoDetails(){
        viewModel.getPromoListListAPIService()
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
        
        viewModel.refreshPromoListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.promoList) != nil {
                    self?.promoList = (self?.viewModel.promoList)!
                    self?.promoCodeTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "No promo code found", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension PromoCodeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if promoList != nil && promoList.count > 0 {
            return promoList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeCell") as! PromoCodeCell
        Cell.initializeCellDetaill(cellDic: promoList[indexPath.row])
        if isCart == true {
            Cell.btnApplyOulet.isHidden = false
        }else{
            Cell.btnApplyOulet.isHidden = true
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 230
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCart == true {
            delegate?.applyPromocodes(value: promoList[indexPath.row].discount! , id : promoList[indexPath.row].id!)
            navigationController?.popViewController(animated: true)
        }else{
            //Cell.btnApplyOulet.isHidden = true
        }
    }
}
