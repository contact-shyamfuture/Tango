//
//  RestourantMenuListVC.swift
//  Tango
//
//  Created by Samir Samanta on 24/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RestourantMenuListVC: BaseViewController {
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
    var shopID : String = ""
    var userdetails = ProfiledetailsModel()
    
    lazy var viewModel: UserCratVM = {
        return UserCratVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.imgLogo.isHidden = true
        headerView.btnBackAction.isHidden = false
        
        menutableView.delegate = self
        menutableView.dataSource = self
        menutableView.register(CartTopCell.nib(), forCellReuseIdentifier: CartTopCell.identifier)
        
        self.menutableView.register(UINib(nibName: "CartListCell", bundle: Bundle.main), forCellReuseIdentifier: "CartListCell")
        
        lblMenuName.text = categoryList?.name
        btnDistance.setTitle("\(categoryList!.estimated_delivery_time ?? 0) mint", for: .normal)
        MenuHeaderImage.sd_setImage(with: URL(string: categoryList!.avatar!))
        ratingView.value = CGFloat(categoryList!.rating ?? 0)
        
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
                    self!.menutableView.reloadData()
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

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func userAddToCart(cell : CartListCell) {
        let indexPath = self.menutableView.indexPath(for: cell)
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
                commonAllertView()
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
    
    func userAddToCartPlus(cell : CartListCell) {
        let indexPath = self.menutableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
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
    
    func userAddToCartMinus(cell : CartListCell){
        let indexPath = self.menutableView.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        let shop_id = userdetails.userCart![0].CartProduct?.shop_id
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
}

extension RestourantMenuListVC : UITableViewDelegate,UITableViewDataSource , UserCartProtocol{
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoryList!.restaurantCategories != nil && categoryList!.restaurantCategories!.count > 0 {
            return categoryList!.restaurantCategories!.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoryList!.restaurantCategories != nil && categoryList!.restaurantCategories!.count > 0 {
            return categoryList!.restaurantCategories![section].categoriesProducts!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
        Cell.intializecelletails(cellDic: categoryList!.restaurantCategories![indexPath.section].categoriesProducts![indexPath.row] , cartDetails : userdetails)
        Cell.delegate = self
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainView = UIStoryboard(name:"Dashboard", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "MenuDetailsVC") as! MenuDetailsVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        label.text = categoryList!.restaurantCategories![section].name
        
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.red // my custom colour
        headerView.backgroundColor = .white

        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
      
}
