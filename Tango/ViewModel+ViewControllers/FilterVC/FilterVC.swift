//
//  FilterVC.swift
//  Tango
//
//  Created by Samir Samanta on 25/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
protocol filterValuesDelegates {
    func filterValues(value : String)
}
class FilterVC: BaseViewController {

    @IBOutlet weak var filterTableView: UITableView!
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var filterDel : filterValuesDelegates?
    var FilterList = [FilterModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        headerView.btnBackAction.isHidden = false
        headerView.imgBackLogo.isHidden = false
        tabBarView.isHidden = true
        headerView.btnHeartOutlet.isHidden = true

        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.register(UINib(nibName: "FilterCell", bundle: Bundle.main), forCellReuseIdentifier: "FilterCell")
        initializeViewModel()
        viewModel.getFilterListAPIService()
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
                
                if  (self?.viewModel.FilterList) != nil {
                    self?.FilterList = (self?.viewModel.FilterList)!
                    self?.filterTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        filterDel?.filterValues(value: "")
    }
    
    @IBAction func resetFilterBtnAction(_ sender: Any) {
        viewModel.getFilterListAPIService()
    }
}

extension FilterVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        }else {
            if FilterList != nil && FilterList.count > 0 {
                return FilterList.count
            }
            return 0
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
            switch indexPath.row {
            case 0:
                Cell.lblItemName.text = "Offers"
            case 1:
                Cell.lblItemName.text = "Pure veg"
            default:
                Cell.lblItemName.text = ""
            }
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
            Cell.lblItemName.text = FilterList[indexPath.row].name
            if FilterList[indexPath.row].isSelected == true {
                Cell.radioCheck.image = UIImage(named: "check")
            }else{
               Cell.radioCheck.image = UIImage(named: "redRadio")
            }
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 20, width: headerView.frame.width, height: headerView.frame.height-30)
        
        if section == 0 {
            label.text = "SHOW RESTAURANTS WITH"
        }else {
            label.text = "CUISINES"
        }
        label.font = .systemFont(ofSize: 17) // my custom font
        label.textColor = UIColor.lightGray // my custom colour
        label.backgroundColor = .white
        headerView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)

        headerView.addSubview(label)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //UITableView.automaticDimension
        return 65//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        }else{
            if FilterList[indexPath.row].isSelected == true {
                FilterList[indexPath.row].isSelected = false
            }else{
                FilterList[indexPath.row].isSelected = true
            }
            filterTableView.reloadData()
        }
    }
}
