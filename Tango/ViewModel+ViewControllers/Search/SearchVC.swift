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
    var shopNearFarList : [SearchShopList]?
    var searchProductList : [SearchProductList]?
    
    lazy var viewCartModel: UserCratVM = {
        return UserCratVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.btnBackAction.isHidden = true
        headerView.imgBackLogo.isHidden = true
        imgDishes.isHidden = true
        imgrestaurant.isHidden = false
        headerView.btnHeartOutlet.isHidden = true
        
        self.SearchTableView.register(UINib(nibName: "SearchRestaurantCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchRestaurantCell")
        
        self.SearchTableView.register(UINib(nibName: "DishesCell", bundle: Bundle.main), forCellReuseIdentifier: "DishesCell")
        
        
        self.SearchTableView.register(UINib(nibName: "DashboardHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "DashboardHeaderCell")
        
        self.txtsearchField.delegate = self
        SearchTableView.delegate = self
        SearchTableView.dataSource = self
        self.tabBarView.imgArray = ["Home","Search2Selected","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 68/255.0, alpha: CGFloat(1)),UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        initializeViewModel()
        initializeProfileViewModel()
        initializeCartViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            getprifleDetails()
        }else{
            
        }
    }
    
    func getprifleDetails(){
        let deviceToken = AppPreferenceService.getString(PreferencesKeys.FCMTokenDeviceID)
        let deviceID = getUUID()
        viewProfileModel.getProfileDetailsAPIService(device_type: "ios", device_token: deviceToken!, device_id: deviceID!)
    }
    
    func searchRestaurantAndDishes(searchValue : String){
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let userID = AppPreferenceService.getString(PreferencesKeys.userID)
            viewModel.getSearchToAPIService(searchString: searchValue, userID: userID!)
            viewModel.getSearchresultNearByMeDetails(searchString: searchValue, userID: userID!)
        }else{
            viewModel.getSearchToAPIService(searchString: searchValue, userID: "0")
            viewModel.getSearchresultNearByMeDetails(searchString: searchValue, userID: "0")
        }
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
        
        viewModel.refreshViewNearFalseClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.searchNearFarDetails.shopList) != nil {
                    self?.shopNearFarList = self?.viewModel.searchNearFarDetails.shopList
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
    
    func commonAllertLoginView(){
        let refreshAlert = UIAlertController(title: "Tango", message: "Do you need to login", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.openSignInViewController()
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func userAddToCart(cell : DishesCell) {
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let indexPath = self.SearchTableView.indexPath(for: cell)
            if  userdetails.userCart != nil && userdetails.userCart!.count > 0 {
                let shop_id = userdetails.userCart![0].CartProduct?.shop_id
                let productDetails = searchProductList![indexPath!.row]
                if shop_id == productDetails.shop_id  {
                    let param = CartParam()
                    let mapLat = AppPreferenceService.getString(PreferencesKeys.mapLat)
                    let mapLong = AppPreferenceService.getString(PreferencesKeys.mapLong)
                    param.latitude = Double(mapLat!)
                    param.longitude = Double(mapLong!)
                    param.quantity = 1
                    param.product_id = productDetails.id
                    viewCartModel.sendUserCartToAPIService(user: param)
                }else{
                    commonAllertView()
                }
            }else{
                let productDetails = searchProductList![indexPath!.row]
                let param = CartParam()
                let mapLat = AppPreferenceService.getString(PreferencesKeys.mapLat)
                let mapLong = AppPreferenceService.getString(PreferencesKeys.mapLong)
                param.latitude = Double(mapLat!)
                param.longitude = Double(mapLong!)
                param.quantity = 1
                param.product_id = productDetails.id
                viewCartModel.sendUserCartToAPIService(user: param)
            }
        }else{
            commonAllertLoginView()
        }
    }
    
    func userAddToCartPlus(cell : DishesCell) {
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
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
                
               let mapLat = AppPreferenceService.getString(PreferencesKeys.mapLat)
                let mapLong = AppPreferenceService.getString(PreferencesKeys.mapLong)
                param.latitude = Double(mapLat!)
                param.longitude = Double(mapLong!)
                param.quantity = quantity! + 1
                param.product_id = productDetails.id
                viewCartModel.sendUserCartToAPIService(user: param)
            }else{
                commonAllertView()
            }
        }else{
            commonAllertLoginView()
        }
    }
    
    func userAddToCartMinus(cell : DishesCell){
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
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
                
                let mapLat = AppPreferenceService.getString(PreferencesKeys.mapLat)
                let mapLong = AppPreferenceService.getString(PreferencesKeys.mapLong)
                param.latitude = Double(mapLat!)
                param.longitude = Double(mapLong!)
                param.quantity = quantity! - 1
                param.product_id = productDetails.id
                viewCartModel.sendUserCartToAPIService(user: param)
            }else{
                commonAllertView()
            }
        }else{
            commonAllertLoginView()
        }
    }
}

extension SearchVC : UITableViewDelegate,UITableViewDataSource , UserDushCartProtocol{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isRestaurant == true {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRestaurant == true {
            if section == 0 {
                if shopList != nil && shopList!.count > 0 {
                    return shopList!.count
                }
                return 0
            }else{
                if shopNearFarList != nil && shopNearFarList!.count > 0 {
                    return shopNearFarList!.count
                }
                return 0
            }
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
           // Cell.initializeCellDetails(cellDic: shopList![indexPath.row])
            if indexPath.section == 0 {
                Cell.initializeCellDetails(cellDic: shopList![indexPath.row])
            }else{
                Cell.initializeCellDetailsNearFalse(cellDic: shopNearFarList![indexPath.row])
            }
            return Cell
            
         }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DishesCell") as! DishesCell
            Cell.initializeCellDetails(cellDic: searchProductList![indexPath.row] , cartDetails : userdetails)
            Cell.delegate = self
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "RESTAURANTS"
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "RESTAURANTS - LITTLE FUTURE AWAY"
            return Cell
        default:
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isRestaurant == true {
            if section == 0 {
                if shopList != nil && shopList!.count > 0 {
                    return 50
                }
                return 0
            }else{
                if shopNearFarList != nil && shopNearFarList!.count > 0 {
                    return 50
                }
                return 0
            }
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
            if indexPath.section == 0 {
                if self.shopList![indexPath.row].shopstatus == "OPEN" {
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
                }
            }else{
                if self.shopNearFarList![indexPath.row].shopstatus == "OPEN" {
                    let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
                    let resDic = RestaurantList()
                    resDic.name = self.shopNearFarList![indexPath.row].name
                    resDic.estimated_delivery_time = self.shopNearFarList![indexPath.row].estimated_delivery_time
                    resDic.avatar = self.shopNearFarList![indexPath.row].avatar
                    resDic.rating = self.shopNearFarList![indexPath.row].rating
                    vc!.categoryList = resDic
                    vc!.userdetails = userdetails
                    vc!.shopID = "\(self.shopNearFarList![indexPath.row].id ?? 0)"
                    self.navigationController?.pushViewController (vc!, animated: true)
                }
            }
            
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
