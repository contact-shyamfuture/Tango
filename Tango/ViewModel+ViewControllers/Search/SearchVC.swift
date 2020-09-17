//
//  SearchVC.swift
//  Tango
//
//  Created by Samir Samanta on 31/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class SearchVC: BaseViewController {
    @IBOutlet weak var txtsearchField: UITextField!
    
    @IBOutlet weak var imgDishes: UIImageView!
    @IBOutlet weak var imgrestaurant: UIImageView!
    @IBOutlet weak var SearchTableView: UITableView!
    var isRestaurant : Bool = true
    lazy var viewModel: SearchVM = {
        return SearchVM()
    }()
    var shopList : [SearchShopList]?
    var searchProductList : [SearchProductList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.btnBackAction.isHidden = true
        imgDishes.isHidden = true
        imgrestaurant.isHidden = false
        
        self.SearchTableView.register(UINib(nibName: "SearchRestaurantCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchRestaurantCell")
        
        self.SearchTableView.register(UINib(nibName: "DishesCell", bundle: Bundle.main), forCellReuseIdentifier: "DishesCell")
        self.txtsearchField.delegate = self
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        self.tabBarView.imgArray = ["Home","Search2Selected","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 68/255.0, alpha: CGFloat(1)),UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        initializeViewModel()
        
    }
    func searchRestaurantAndDishes(searchValue : String){
        let userID = AppPreferenceService.getString(PreferencesKeys.userID)
        viewModel.getSearchToAPIService(searchString: searchValue, userID: userID!)
    }
    
    @IBAction func resturantBtnAction(_ sender: Any) {
        imgDishes.isHidden = true
        imgrestaurant.isHidden = false
        isRestaurant = true
        SearchTableView.reloadData()
        
    }
    
    @IBAction func dishesBtnAction(_ sender: Any) {
        imgDishes.isHidden = false
        imgrestaurant.isHidden = true
        isRestaurant = false
        SearchTableView.reloadData()
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
                
                if  (self?.viewModel.searchDetails.shopList) != nil {
                    self?.shopList = self?.viewModel.searchDetails.shopList
                    self?.SearchTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
                
                if  (self?.viewModel.searchDetails.searchProductList) != nil {
                    self?.searchProductList = self?.viewModel.searchDetails.searchProductList
                    self?.SearchTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension SearchVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isRestaurant == true {
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRestaurant == true {
            if shopList != nil && shopList!.count > 0 {
                return shopList!.count
            }
            return 0
        }else{
            if searchProductList != nil && searchProductList!.count > 0 {
                return searchProductList!.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if isRestaurant == true {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SearchRestaurantCell") as! SearchRestaurantCell
            Cell.initializeCellDetails(cellDic: shopList![indexPath.row])
            return Cell
            
         }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DishesCell") as! DishesCell
            Cell.initializeCellDetails(cellDic: searchProductList![indexPath.row])
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 30, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        label.text = ""
        
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.black // my custom colour
        headerView.backgroundColor = .white

        headerView.addSubview(label)

        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isRestaurant == true {
            return 0
        }else{
          return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRestaurant == true {
            return 200
        }else{
          return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension SearchVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        self.searchRestaurantAndDishes(searchValue: updateText as String)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
