//
//  RestourantMenuListVC.swift
//  Tango
//
//  Created by Samir Samanta on 24/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Alamofire
class RestourantMenuListVC: BaseViewController , AddFavoritesProtocal {
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var itemView: UIStackView!
    
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var btnDistance: UIButton!
    
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var MenuHeaderImage: UIImageView!
    @IBOutlet weak var menutableView: UITableView!
    var categoryList : RestaurantList?
    var featureList : [RestaurantFeaturedProduct]?
    var shopID : String = ""
    var userdetails = ProfiledetailsModel()
    
    lazy var viewModel: UserCratVM = {
        return UserCratVM()
    }()
    
    var favoritesList : [FavoritesList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        headerView.btnBackAction.isHidden = false
        headerView.btnHeartOutlet.isHidden = false
        headerView.imgBackLogo.isHidden = false
        headerView.delegate = self
        menutableView.delegate = self
        menutableView.dataSource = self
        menutableView.register(CartTopCell.nib(), forCellReuseIdentifier: CartTopCell.identifier)
        
        self.menutableView.register(UINib(nibName: "CartListCell", bundle: Bundle.main), forCellReuseIdentifier: "CartListCell")
        
        self.menutableView.register(UINib(nibName: "FeatureProductCell", bundle: Bundle.main), forCellReuseIdentifier: "FeatureProductCell")
        
        
        if let name = self.categoryList?.name {
            self.lblMenuName.text = name
        }else{
             self.lblMenuName.text = ""
        }
        
        if let time = self.categoryList!.estimated_delivery_time {
            self.btnDistance.setTitle("\(time) mint", for: .normal)
        }else{
            self.btnDistance.setTitle("0 mint", for: .normal)
        }
        
        if let avatar = self.categoryList!.avatar {
            self.MenuHeaderImage.sd_setImage(with: URL(string: avatar))
        }
        
        if let rating = self.categoryList!.rating {
            self.ratingView.value = CGFloat(rating )
        }else{
            self.ratingView.value = CGFloat(0 )
        }
        
        
        if userdetails.userCart != nil && userdetails.userCart!.count > 0 {
            itemView.isHidden = false
            var price = 0
            for obj in userdetails.userCart! {
                price += (obj.CartProduct?.cartItemPrice?.price!)!
            }
            lblItemCount.text = "\(userdetails.userCart!.count) Items"
            lblCurrency.text = "\(userdetails.userCart![0].CartProduct?.cartItemPrice?.currency ?? "")"
            lblAmount.text = "\(price)"
        }else{
            itemView.isHidden = true
            lblItemCount.text = "0 Items"
            lblCurrency.text = ""
            lblAmount.text = "0"
        }
        self.tabBarView.imgArray = ["HomeSelected","Search","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        
        initializeViewModel()
        getcategoryList()
        getFavorites()
    }
    
    func getFavorites(){
        viewModel.getFavoritesListToAPIService()
    }
    
    func addFavorites(){
        if self.favoritesList!.contains(where: {$0.shop_id == Int(self.shopID)}) {            
            viewModel.removeFavoritesToAPIService(shopId : shopID)
        } else {
            let param = AddFavParam()
            param.shop_id = Int(shopID)
            viewModel.addFavoritesToAPIService(user: param)
        }
    }
    
    func getcategoryList(){
       // AppPreferenceService.setString(String((self!.userdetails.id!)), key: PreferencesKeys.userID)
        let userID = AppPreferenceService.getString(PreferencesKeys.userID)
        viewModel.getCategoryListToAPIService(shopID : shopID, user_id : userID!)
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
                
                if  (self?.viewModel.userCartDetails.userCart) != nil {
                    self!.userdetails.userCart = self?.viewModel.userCartDetails.userCart
                    
                    if self!.userdetails.userCart != nil && self!.userdetails.userCart!.count > 0 {
                        self!.itemView.isHidden = false
                        var price = 0
                        for obj in self!.userdetails.userCart! {
                            price += (obj.CartProduct?.cartItemPrice?.price!)!
                        }
                        self!.lblItemCount.text = "\(self!.userdetails.userCart!.count) Items"
                        self!.lblCurrency.text = "\(self!.userdetails.userCart![0].CartProduct?.cartItemPrice?.currency ?? "")"
                        self!.lblAmount.text = "\(price)"
                    }else{
                        self!.itemView.isHidden = true
                        self!.lblItemCount.text = "0 Items"
                        self!.lblCurrency.text = ""
                        self!.lblAmount.text = "0"
                    }
                    
                    self!.menutableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshCategoryListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if (self?.viewModel.categoryList) != nil {
                    self!.categoryList = self?.viewModel.categoryList
                    self!.featureList = self?.viewModel.categoryList?.featureList
                    if let name = self!.categoryList?.name {
                        self!.lblMenuName.text = name
                    }else{
                         //self!.lblMenuName.text = ""
                    }
                    
                    if let time = self!.categoryList!.estimated_delivery_time {
                        self!.btnDistance.setTitle("\(time) mint", for: .normal)
                    }else{
                        //self!.btnDistance.setTitle("0 mint", for: .normal)
                    }
                    
                    if let avatar = self!.categoryList!.avatar {
                        self!.MenuHeaderImage.sd_setImage(with: URL(string: avatar))
                    }
                    
                    if let rating = self!.categoryList!.rating {
                        self!.ratingView.value = CGFloat(rating )
                    }else{
                        //self!.ratingView.value = CGFloat(0 )
                    }
                    self!.menutableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        viewModel.refreshFavoritesListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.favoritesDetails.favoritesList) != nil {
                    self!.favoritesList = self?.viewModel.favoritesDetails.favoritesList
                    
                    if self!.favoritesList!.contains(where: {$0.shop_id == Int(self!.shopID)}) {
                        self!.headerView.btnHeartOutlet.setImage(UIImage(named: "RedHeart"), for: .normal)
                    } else {
                       self!.headerView.btnHeartOutlet.setImage(UIImage(named: "whiteHeart"), for: .normal)
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshAddFavoritesViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.addFavDetails.message) != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.addFavDetails.message)!, okButtonText: okText, completion: {

                        self!.getFavorites()
                    })
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshRemoveFavoritesViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.addFavDetails.message) != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.addFavDetails.message)!, okButtonText: okText, completion: {

                        self!.getFavorites()
                    })
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnViewCartAction(_ sender: Any) {
        
        let mainView = UIStoryboard(name:"Cart", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func commonAllertView(){
        let refreshAlert = UIAlertController(title: "Replace cart item?", message: "Do you want to discard the selected dishes and add dishes from this restaurant", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func userAddToCart(cell : CartListCell) {
        
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let indexPath = self.menutableView.indexPath(for: cell)
            if featureList != nil && featureList!.count > 0 {
                if  userdetails.userCart != nil && userdetails.userCart!.count > 0 {
                    let shop_id = userdetails.userCart![0].CartProduct?.shop_id
                    let productDetails = categoryList!.restaurantCategories![indexPath!.section - 1].categoriesProducts![indexPath!.row]
                    if shop_id == productDetails.shop_id  {
                        let param = CartParam()
                        param.latitude = 22.4705668
                        param.longitude = 88.3524203
                        param.quantity = 1
                        param.product_id = productDetails.id
                        viewModel.sendUserCartToAPIService(user: param)
                    }else{
                        commonAllertView()
                    }
                }else{
                    let productDetails = categoryList!.restaurantCategories![indexPath!.section - 1].categoriesProducts![indexPath!.row]
                    let param = CartParam()
                    param.latitude = 22.4705668
                    param.longitude = 88.3524203
                    param.quantity = 1
                    param.product_id = productDetails.id
                    viewModel.sendUserCartToAPIService(user: param)
                }
            }else{
                if  userdetails.userCart != nil && userdetails.userCart!.count > 0 {
                    let shop_id = userdetails.userCart![0].CartProduct?.shop_id
                    let productDetails = categoryList!.restaurantCategories![indexPath!.section].categoriesProducts![indexPath!.row]
                    if shop_id == productDetails.shop_id  {
                        let param = CartParam()
                        param.latitude = 22.4705668
                        param.longitude = 88.3524203
                        param.quantity = 1
                        param.product_id = productDetails.id
                        viewModel.sendUserCartToAPIService(user: param)
                    }else{
                        //commonAllertView()
                        
                        let refreshAlert = UIAlertController(title: "Replace cart item?", message: "Do you want to discard the selected dishes and add dishes from this restaurant", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                          let url = "http://166.62.54.122/swiggy/public/api/user/clear/cart"
                          let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
                           Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header).responseString { response in
                              self.removeLoaderView()
                              print(response)
                              let json = response.result.value
                                let statusCode = response.response?.statusCode
                                  if statusCode == 200 {
                                     let param = CartParam()
                                     param.latitude = 22.4705668
                                     param.longitude = 88.3524203
                                     param.quantity = 1
                                     param.product_id = productDetails.id
                                       self.viewModel.sendUserCartToAPIService(user: param)
                                  }
                           }

                          }))
                        

                        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                          
                          }))

                        present(refreshAlert, animated: true, completion: nil)
                    }
                }else{
                    let productDetails = categoryList!.restaurantCategories![indexPath!.section].categoriesProducts![indexPath!.row]
                    let param = CartParam()
                    param.latitude = 22.4705668
                    param.longitude = 88.3524203
                    param.quantity = 1
                    param.product_id = productDetails.id
                    viewModel.sendUserCartToAPIService(user: param)
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }
    }
    
    func userAddToCartPlus(cell : CartListCell) {
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let indexPath = self.menutableView.indexPath(for: cell)
            var quantity : Int?
            let param = CartParam()
            let shop_id = userdetails.userCart![0].CartProduct?.shop_id
            if featureList != nil && featureList!.count > 0 {
                let productDetails = categoryList!.restaurantCategories![indexPath!.section - 1].categoriesProducts![indexPath!.row]
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
                    viewModel.sendUserCartToAPIService(user: param)
                }else{
                    commonAllertView()
                }
            }else{
                let productDetails = categoryList!.restaurantCategories![indexPath!.section].categoriesProducts![indexPath!.row]
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
                    viewModel.sendUserCartToAPIService(user: param)
                }else{
                    commonAllertView()
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }
        
    }
    
    func userAddToCartMinus(cell : CartListCell){
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let indexPath = self.menutableView.indexPath(for: cell)
            var quantity : Int?
            let param = CartParam()
            let shop_id = userdetails.userCart![0].CartProduct?.shop_id
            if featureList != nil && featureList!.count > 0 {
                let productDetails = categoryList!.restaurantCategories![indexPath!.section - 1].categoriesProducts![indexPath!.row]
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
                    viewModel.sendUserCartToAPIService(user: param)
                }else{
                    commonAllertView()
                }
            }else{
                let productDetails = categoryList!.restaurantCategories![indexPath!.section].categoriesProducts![indexPath!.row]
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
                    viewModel.sendUserCartToAPIService(user: param)
                }else{
                    commonAllertView()
                }
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }
    }
    
    func userAddToCart(cell : FeatureProductCell){
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            let indexPath = self.menutableView.indexPath(for: cell)
            if  userdetails.userCart != nil && userdetails.userCart!.count > 0 {
                let shop_id = userdetails.userCart![0].CartProduct?.shop_id
                let productDetails = featureList![indexPath!.row]
                if shop_id == productDetails.shop_id  {
                    let param = CartParam()
                    param.latitude = 22.4705668
                    param.longitude = 88.3524203
                    param.quantity = 1
                    param.product_id = productDetails.id
                    viewModel.sendUserCartToAPIService(user: param)
                }else{
                   // commonAllertView()
                    let refreshAlert = UIAlertController(title: "Replace cart item?", message: "Do you want to discard the selected dishes and add dishes from this restaurant", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                      
                        let url = "http://166.62.54.122/swiggy/public/api/user/clear/cart"
                        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
                         Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header).responseString { response in
                            self.removeLoaderView()
                            print(response)
                            let json = response.result.value
                              let statusCode = response.response?.statusCode
                                if statusCode == 200 {
                                  let param = CartParam()
                                   param.latitude = 22.4705668
                                   param.longitude = 88.3524203
                                   param.quantity = 1
                                   param.product_id = productDetails.id
                                     self.viewModel.sendUserCartToAPIService(user: param)
                                }
                         }
                      }))

                    refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                      
                      }))

                    present(refreshAlert, animated: true, completion: nil)
                }
            }else{
                let productDetails = featureList![indexPath!.row]
                let param = CartParam()
                param.latitude = 22.4705668
                param.longitude = 88.3524203
                param.quantity = 1
                param.product_id = productDetails.id
                viewModel.sendUserCartToAPIService(user: param)
            }
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }
    }
    
    func userAddToCartPlus(cell : FeatureProductCell){
        let indexPath = self.menutableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        
        let productDetails = featureList![indexPath!.row]
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
            viewModel.sendUserCartToAPIService(user: param)
        }else{
            commonAllertView()
        }
    }
    
    func userAddToCartMinus(cell : FeatureProductCell){
        
        let indexPath = self.menutableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        
        let productDetails = featureList![indexPath!.row]
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
            viewModel.sendUserCartToAPIService(user: param)
        }else{
            commonAllertView()
        }
    }
}

extension RestourantMenuListVC : UITableViewDelegate,UITableViewDataSource , UserCartProtocol , UserFeatureCartProtocol{
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoryList != nil {
            if categoryList!.restaurantCategories != nil && categoryList!.restaurantCategories!.count > 0 {
                if featureList != nil && featureList!.count > 0 {
                    return categoryList!.restaurantCategories!.count + 1
                }else{
                    return categoryList!.restaurantCategories!.count
                }
                
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if featureList != nil && featureList!.count > 0 {
            if section == 0 {
                return featureList!.count
            }else{
                if categoryList!.restaurantCategories != nil && categoryList!.restaurantCategories!.count > 0 {
                    return categoryList!.restaurantCategories![section - 1].categoriesProducts!.count
                }else{
                    return 0
                }
            }
        }else{
            if categoryList!.restaurantCategories != nil && categoryList!.restaurantCategories!.count > 0 {
                return categoryList!.restaurantCategories![section].categoriesProducts!.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if featureList != nil && featureList!.count > 0 {
            if indexPath.section == 0 {
                let Cell = tableView.dequeueReusableCell(withIdentifier: "FeatureProductCell") as! FeatureProductCell
                Cell.initializeCellDetails(cellDic: featureList![indexPath.row] , cartDetails : userdetails)
                Cell.delegate = self
                return Cell
            }else{
                let Cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
                Cell.intializecelletails(cellDic: categoryList!.restaurantCategories![indexPath.section - 1].categoriesProducts![indexPath.row] , cartDetails : userdetails)
                Cell.delegate = self
                return Cell
            }
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
            Cell.intializecelletails(cellDic: categoryList!.restaurantCategories![indexPath.section].categoriesProducts![indexPath.row] , cartDetails : userdetails)
            Cell.delegate = self
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let mainView = UIStoryboard(name:"Dashboard", bundle: nil)
//        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "MenuDetailsVC") as! MenuDetailsVC
//        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if featureList != nil && featureList!.count > 0 {
            if indexPath.section == 0 {
                return 250
            }else{
                return 80
            }
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if featureList != nil && featureList!.count > 0 {
            if section == 0 {
                label.text = "FEATURED PRODUCTS"
            }else{
                label.text = categoryList!.restaurantCategories![section - 1].name
            }
        }else{
            label.text = categoryList!.restaurantCategories![section].name
        }
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.black // my custom colour
        headerView.backgroundColor = .white
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
