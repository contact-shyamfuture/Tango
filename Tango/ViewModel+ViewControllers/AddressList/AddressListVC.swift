//
//  AddressListVC.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class AddressListVC: BaseViewController {

    @IBOutlet weak var tableAddressList: UITableView!
    var delegate : DeliveryLocationSaved?
    
    lazy var viewModel: AddressListVM = {
        return AddressListVM()
    }()
    var addressList = [AddressListModel]()
    var isSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        self.tableAddressList.delegate = self
        self.tableAddressList.dataSource = self
        self.tableAddressList.register(UINib(nibName: "AddressListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddressListCell")
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ApiCalled()
    }
    
    private func ApiCalled(){
        viewModel.getAddressList()
    }
    
    @IBAction func btnAddAddress(_ sender: Any) {
        let mainView = UIStoryboard(name:"Other", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
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
                self?.addressList = self?.viewModel.addressList ?? []
                if (self?.addressList.count)! > 0{
                    self?.tableAddressList.reloadData()
                }
            }
        }
    }
}

extension AddressListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            if isSelected == true {
                return 1
            }else{
                return 0
            }
            
        }else {
            return self.addressList.count
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
            //Cell.btnStackVw.isHidden = true
            Cell.lblTitle.text = "Current Location"
            Cell.lblAddress.text = "Lorem Ipsum is simply"
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
            let list = self.addressList[indexPath.row]
            //Cell.btnStackVw.isHidden = false
            Cell.lblTitle.text = list.type?.uppercased()
            if list.type?.uppercased() == "HOME" {
                Cell.imgType.image = UIImage(named: "Home")
            }else{
                Cell.imgType.image = UIImage(named: "location")
            }
            Cell.lblAddress.text = list.map_address
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        if section == 0 {
            label.text = ""
        }else {
            label.text = "SAVED ADDRESS"
        }
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.gray // my custom colour
        headerView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)

        headerView.addSubview(label)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //UITableView.automaticDimension
        if indexPath.section == 0 {
            if isSelected == true {
                return 100
            }else{
                return 0
            }
        }else{
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected == true {
            navigationController?.popViewController(animated: true)
            delegate?.getDeliveryLocation(Address: self.addressList[indexPath.row].map_address!, addressID: self.addressList[indexPath.row].id!)
        }
    }
}
