//
//  OrderListVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 26/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class OrderListVC: BaseViewController {
    
    //Outlet Properties
    @IBOutlet weak var tblVwOrderList : UITableView!
    
    lazy var viewModel: OrderListVM = {
        return OrderListVM()
    }()
    
    var orderList = [OrderListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        initializeViewModel()
        viewModel.getOrderList()
    }
    private func configureUI(){
        
        tblVwOrderList.delegate = self
        tblVwOrderList.dataSource = self
        tblVwOrderList.register(OrderListCell.nib(), forCellReuseIdentifier: OrderListCell.identifier)
        tblVwOrderList.tableFooterView = UIView()
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
                self?.orderList = self?.viewModel.orderList ?? []
                self?.tblVwOrderList.reloadData()
            }
        }
        
    }

}
extension OrderListVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tblVwOrderList.layer.bounds.width, height: tblVwOrderList.layer.bounds.height))
        vw.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        let titleLbl = UILabel(frame: CGRect(x: 20, y: 3, width: tblVwOrderList.layer.bounds.width - 10, height: 50))
        titleLbl.text = "Current Orders"
        titleLbl.font = UIFont.init(name: "Roboto-Regular", size: 20)
        vw.addSubview(titleLbl)
        return vw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderListCell.identifier, for: indexPath) as? OrderListCell else {return UITableViewCell()}
        let item = self.orderList[indexPath.row]
        cell.cellConfigUI(with: item)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.orderList[indexPath.row]
        let vc = UIStoryboard.init(name: "Other", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryDetailsVC") as? DeliveryDetailsVC
        vc?.orderID = "\(item.id ?? 0)"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
