//
//  CartVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class CartVC: BaseViewController , DeliveryLocationSaved , PromoCodeApply{
    
    @IBOutlet weak var otherTipsTextField: UITextField!
    @IBOutlet weak var otherTipValue: RoundUIView!
    @IBOutlet weak var txtAddNoteView: UITextView!
    @IBOutlet weak var addNotesMainView: RoundUIView!
    @IBOutlet weak var addBackroundView: UIView!
    //Outlet Properties..
    @IBOutlet weak var noCartImg: UIImageView!
    @IBOutlet weak var tblVw : UITableView!
    var isAddressSelected = false
    
    lazy var viewModel: UserCratVM = {
        return UserCratVM()
    }()
    
    var orderSave = OrderSaveModel()
    var userCart : [ProfileCartModel]?
    var userCartList = UserCartModel()
    
    var userdetails = ProfiledetailsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.tabBarView.imgArray = ["Home","Search","finished2Selected","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        
        headerView.btnHeartOutlet.isHidden = true
        headerView.imgBackLogo.isHidden = true
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
        otherTipValue.isHidden = true
        txtAddNoteView.delegate = self
        txtAddNoteView.text = "Enter your notes"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addBackroundView.addGestureRecognizer(tap)
        
        self.tblVw.register(UINib(nibName: "DeliveryTipCell", bundle: Bundle.main), forCellReuseIdentifier: "DeliveryTipCell")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
        otherTipValue.isHidden = true
    }
    private func configureUI(){
        //topHeaderSet(vc : self)
        
        self.noCartImg.isHidden = true
        headerView.btnBackAction.isHidden = true
        isAddressSelected = true
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.tableFooterView = UIView()
        tblVw.register(CartTopCell.nib(), forCellReuseIdentifier: CartTopCell.identifier)
        tblVw.register(CartListCell.nib(), forCellReuseIdentifier: CartListCell.identifier)
        tblVw.register(CartNoteCell.nib(), forCellReuseIdentifier: CartNoteCell.identifier)
        tblVw.register(CartDetailsCell.nib(), forCellReuseIdentifier: CartDetailsCell.identifier)
        tblVw.register(CartAddressCell.nib(), forCellReuseIdentifier: CartAddressCell.identifier)
        initializeViewModel()
        getUserCartList()
    }
    func getUserCartList(){
        viewModel.getUserCartListToAPIService()
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
        
        viewModel.refreshCartListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.userCartList.userCart) != nil {
                    
                    
                    self?.userCart = self?.viewModel.userCartList.userCart
                    self?.userCartList = (self?.viewModel.userCartList)!
                    if self?.userCart != nil && (self?.userCart!.count)! > 0 {
                        self!.noCartImg.isHidden = true
                        self?.tblVw.reloadData()
                    }else{
                        self!.noCartImg.isHidden = false
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.userCartDetails.userCart) != nil {
                    self!.userdetails.userCart = self?.viewModel.userCartDetails.userCart
                    
                    if self!.userdetails.userCart != nil && self!.userdetails.userCart!.count > 0 {
                        self!.getUserCartList()
                    }else{
                        self!.getUserCartList()
                    }
                    self!.tblVw.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        viewModel.refreshLocationCheckViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.checkDis.proceed) != nil {
                    if self?.viewModel.checkDis.proceed == "true"{
                        self!.continueNavigation()
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.checkDis.msg)!, okButtonText: okText, completion: nil)
                    }
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Error", okButtonText: okText, completion: nil)
                }
            }
        }
        
    }
    
    func selectAddress(){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC
        vc?.delegate = self
        vc?.isSelected = true
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func getDeliveryLocation(Address : String, addressID : Int , adddic : AddressListModel){
        orderSave.user_address_id = addressID
        orderSave.user_address = Address
        orderSave.addressType = adddic.type!
        tblVw.reloadData()
    }
    
    func applyPromocodes(value : Int , id : Int){
        orderSave.wallet = value//"\(value)"
        orderSave.promoID = id
        tblVw.reloadData()
    }
    
    func addAddress(){
        
        let mainView = UIStoryboard(name:"Other", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func orderContinue(){
        let param = CheckLocationParam()
        param.address_id = "\(orderSave.user_address_id ?? 0)"
        param.near_by = "true"
        param.restaurant_id = "\(self.userCart![0].CartProduct?.shop_id ?? 0)"
        viewModel.CheckLocationToAPIService(user: param)
    }
    
    func continueNavigation(){
        let vc = UIStoryboard.init(name: "Payment", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
        vc!.orderSave = orderSave
        vc!.userCart = userCart
        vc!.userCartList = userCartList
        self.navigationController?.pushViewController (vc!, animated: true)
    }
    
    func customNotesAdd(){
        otherTipValue.isHidden = true
        addNotesMainView.isHidden = false
        addBackroundView.isHidden = false
    }
    
    @IBAction func submitAddNoteBtnView(_ sender: Any) {
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
        orderSave.note = txtAddNoteView.text
        tblVw.reloadData()
    }
    
    func promocodeApply(){
        if orderSave.wallet == 0 {
            let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromoCodeVC") as? PromoCodeVC
            vc!.delegate = self
            vc!.isCart = true
            self.navigationController?.pushViewController (vc!, animated: true)
        }else{
            orderSave.wallet = 0
            tblVw.reloadData()
        }
    }
    
    func tipsValue(value : String){
        if value == "Other" {
            
            addNotesMainView.isHidden = true
            addBackroundView.isHidden = false
            otherTipValue.isHidden = false
            
        }else{
            print("Delivery tips : \(value)")
            orderSave.tips_amount = value
            tblVw.reloadData()
        }
    }
    
    @IBAction func otherTipsSubmitBtnAction(_ sender: Any) {
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
        otherTipValue.isHidden = true
        orderSave.tips_amount = otherTipsTextField.text!
        orderSave.tips_Othe_amount = otherTipsTextField.text!
        tblVw.reloadData()
    }
    
    
    
    func userAddToCart(cell : CartListCell) {
        
    }
    
    func userAddToCartPlus(cell : CartListCell) {
        let indexPath = self.tblVw.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        //let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        let productDetails = self.userCart![indexPath!.row]
        for obj in self.userCart! {
            quantity = obj.quantity
            param.cart_id = obj.id
        }
        param.latitude = 22.4705668
        param.longitude = 88.3524203
        param.quantity = quantity! + 1
        param.product_id = productDetails.product_id
        viewModel.sendUserCartToAPIService(user: param)
    }
    
    func userAddToCartMinus(cell : CartListCell){
        let indexPath = self.tblVw.indexPath(for: cell)
        var quantity : Int?
        let param = CartParam()
        //let shop_id = userdetails.userCart![0].CartProduct?.shop_id
        let productDetails = self.userCart![indexPath!.row]
        for obj in self.userCart! {
           quantity = obj.quantity
            param.cart_id = obj.id
        }
        param.latitude = 22.4705668
        param.longitude = 88.3524203
        param.quantity = quantity! - 1
        param.product_id = productDetails.product_id
        viewModel.sendUserCartToAPIService(user: param)
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
}

extension CartVC : UITableViewDelegate,UITableViewDataSource , addressSelectionDelegate , CustomNotesAdd , promocodeDelegates , updatetipsvalue , UserCartProtocol {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            if self.userCart != nil && (self.userCart?.count)! > 0 {
                return self.userCart!.count
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
         case 0:
             let Cell = tableView.dequeueReusableCell(withIdentifier: "CartTopCell") as! CartTopCell
             if self.userCart != nil && (self.userCart?.count)! > 0 {
                 Cell.initializecellDetails(cellDic: self.userCart![0])
             }
             return Cell
         case 1:
             let Cell = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell
             
             Cell.initializecellDetails(cellDic: self.userCart![indexPath.row])
             Cell.delegate = self
             return Cell
         case 2:
             let Cell = tableView.dequeueReusableCell(withIdentifier: "CartNoteCell") as! CartNoteCell
             Cell.noteDelegate = self
             Cell.lblNote.text = orderSave.note
             return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryTipCell") as! DeliveryTipCell
            Cell.delegate = self
            return Cell
        case 4:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailsCell") as! CartDetailsCell
            if self.userCart != nil && (self.userCart?.count)! > 0 {
                Cell.initializeCellDetails(cellDic: userCartList , orderDetails : orderSave)
            }
            Cell.promocodeDelegate = self
            return Cell
        case 5:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CartAddressCell") as! CartAddressCell
            Cell.delegate = self
            if orderSave.user_address_id != nil {
                Cell.btnCOntiniueAction.isHidden = false
                Cell.changeAddress.isHidden = false
                Cell.lblAddress.text = orderSave.user_address
                Cell.lblAddressType.text = orderSave.addressType
            }else{
                Cell.btnCOntiniueAction.isHidden = true
                Cell.changeAddress.isHidden = true
            }
            return Cell
        
         default:
             return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return 80
        case 2:
            return UITableView.automaticDimension
        case 3:
            return 200
        case 4:
            return 440
        case 5:
            if orderSave.user_address_id != nil {
                return 150
            }else{
                return 120
            }
        default:
            return 0
        }
    }
}
extension  CartVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Enter your notes" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == "Enter your notes" {
            
        }else{
            textView.text = "Enter your notes"
        }
    }
    
}
