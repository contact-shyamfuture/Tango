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
    lazy var viewProfileModel: DashboardVM = {
        return DashboardVM()
    }()
    var userdetails = ProfiledetailsModel()
    
    var shopList : [SearchShopList]?
    var searchProductList : [SearchProductList]?
    
    lazy var viewCartModel: UserCratVM = {
        return UserCratVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.btnBackAction.isHidden = true
        imgDishes.isHidden = true
        imgrestaurant.isHidden = false
        headerView.btnHeartOutlet.isHidden = true
        
        self.SearchTableView.register(UINib(nibName: "SearchRestaurantCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchRestaurantCell")
        
        self.SearchTableView.register(UINib(nibName: "DishesCell", bundle: Bundle.main), forCellReuseIdentifier: "DishesCell")
        self.txtsearchField.delegate = self
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        self.tabBarView.imgArray = ["Home","Search2Selected","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 68/255.0, alpha: CGFloat(1)),UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        initializeViewModel()
        initializeProfileViewModel()
        initializeCartViewModel()
        getprifleDetails()
        
    }
    
    func getprifleDetails(){
        let deviceToken = AppPreferenceService.getString(PreferencesKeys.FCMTokenDeviceID)
        let deviceID = getUUID()
        viewProfileModel.getProfileDetailsAPIService(device_type: "ios", device_token: deviceToken!, device_id: deviceID!)
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
    
    func initializeProfileViewModel() {
        viewProfileModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewProfileModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewProfileModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewProfileModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        
        viewProfileModel.refreshprofileViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewProfileModel.userdetails.id) != nil {
                    self?.userdetails = (self?.viewProfileModel.userdetails)!
                    print(self!.userdetails.id!)
                    
                    AppPreferenceService.setString(String((self!.userdetails.id!)), key: PreferencesKeys.userID)
                    self!.SearchTableView.reloadData()
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile", okButtonText: okText, completion: nil)
                }
            }
        }
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
    
    func initializeCartViewModel() {
        viewCartModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewCartModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewCartModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewCartModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewCartModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewCartModel.userCartDetails.userCart) != nil {
                    
                    
                    if self?.viewCartModel.userCartDetails.userCart != nil && (self?.viewCartModel.userCartDetails.userCart!.count)! > 0 {
                        self!.getprifleDetails()
                    }else{
                        self!.getprifleDetails()
                    }
                    self!.SearchTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func getUUID() -> String? {

        // create a keychain helper instance
        let keychain = KeychainAccess()

        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "com.myorg.myappid.unique_uuid"

        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }

        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }

        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)

        // return new id
        return newId
    }
    func commonAllertView(){
        let refreshAlert = UIAlertController(title: "Replace cart item?", message: "Do you want to discard the selected dishes and add dishes from this restaurant", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func userAddToCart(cell : DishesCell) {
        let indexPath = self.SearchTableView.indexPath(for: cell)
        if  userdetails.userCart != nil && userdetails.userCart!.count > 0 {
            let shop_id = userdetails.userCart![0].CartProduct?.shop_id
            let productDetails = searchProductList![indexPath!.row]
            if shop_id == productDetails.shop_id  {
                let param = CartParam()
                param.latitude = 22.4705668
                param.longitude = 88.3524203
                param.quantity = 1
                param.product_id = productDetails.id
                viewCartModel.sendUserCartToAPIService(user: param)
            }else{
                commonAllertView()
            }
        }else{
            let productDetails = searchProductList![indexPath!.row]
            let param = CartParam()
            param.latitude = 22.4705668
            param.longitude = 88.3524203
            param.quantity = 1
            param.product_id = productDetails.id
            viewCartModel.sendUserCartToAPIService(user: param)
        }
    }
    
    func userAddToCartPlus(cell : DishesCell) {
        let indexPath = self.SearchTableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        let productDetails = searchProductList![indexPath!.row]
        for obj in userdetails.userCart! {
            if productDetails.id == obj.product_id {
                quantity = obj.quantity
                param.cart_id = obj.id
            }
        }
        
        if shop_id == productDetails.shop_id  {
            
            param.latitude = 22.4705668
            param.longitude = 88.3524203
            param.quantity = quantity! + 1
            param.product_id = productDetails.id
            viewCartModel.sendUserCartToAPIService(user: param)
        }else{
            commonAllertView()
        }
    }
    
    func userAddToCartMinus(cell : DishesCell){
        let indexPath = self.SearchTableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        let productDetails = searchProductList![indexPath!.row]
        for obj in userdetails.userCart! {
            if productDetails.id == obj.product_id {
                quantity = obj.quantity
                param.cart_id = obj.id
            }
        }
        
        if shop_id == productDetails.shop_id  {
            
            param.latitude = 22.4705668
            param.longitude = 88.3524203
            param.quantity = quantity! - 1
            param.product_id = productDetails.id
            viewCartModel.sendUserCartToAPIService(user: param)
        }else{
            commonAllertView()
        }
    }
}

extension SearchVC : UITableViewDelegate,UITableViewDataSource , UserDushCartProtocol{
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
            Cell.initializeCellDetails(cellDic: searchProductList![indexPath.row] , cartDetails : userdetails)
            Cell.delegate = self
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
        if isRestaurant == true {
            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
            let resDic = RestaurantList()
            resDic.name = self.shopList![indexPath.row].name
            resDic.estimated_delivery_time = self.shopList![indexPath.row].estimated_delivery_time
            resDic.avatar = self.shopList![indexPath.row].avatar
            resDic.rating = self.shopList![indexPath.row].rating
            vc!.categoryList = resDic
            vc!.userdetails = userdetails
            vc!.shopID = "\(self.shopList![indexPath.row].id ?? 0)"
            self.navigationController?.pushViewController (vc!, animated: true)
        }else{
            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
            let resDic = RestaurantList()
            resDic.name = self.searchProductList![indexPath.row].shopList!.name
            resDic.estimated_delivery_time = self.searchProductList![indexPath.row].shopList!.estimated_delivery_time
            resDic.avatar = self.searchProductList![indexPath.row].shopList!.avatar
            resDic.rating = self.searchProductList![indexPath.row].shopList!.rating
            vc!.categoryList = resDic
            vc!.userdetails = userdetails
            vc!.shopID = "\(self.searchProductList![indexPath.row].shop_id ?? 0)"
            self.navigationController?.pushViewController (vc!, animated: true)
        }
    }
}

extension SearchVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        if updateText.length  > 2 {
            self.searchRestaurantAndDishes(searchValue: updateText as String)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
