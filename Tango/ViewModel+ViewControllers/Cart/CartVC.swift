//
//  CartVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 14/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class CartVC: BaseViewController , DeliveryLocationSaved , PromoCodeApply{
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.tabBarView.imgArray = ["Home","Search","finished2Selected","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        
        
        
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
        txtAddNoteView.delegate = self
        txtAddNoteView.text = "Enter your notes"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addBackroundView.addGestureRecognizer(tap)
       
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        addNotesMainView.isHidden = true
        addBackroundView.isHidden = true
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
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func selectAddress(){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func getDeliveryLocation(Address : String, addressID : Int){
        orderSave.user_address_id = addressID
        orderSave.user_address = Address
        tblVw.reloadData()
    }
    func applyPromocodes(value : Int){
        orderSave.wallet = value//"\(value)"
        tblVw.reloadData()
    }
    
    func addAddress(){
        
        let mainView = UIStoryboard(name:"Other", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func orderContinue(){
        
        let vc = UIStoryboard.init(name: "Payment", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
        vc!.orderSave = orderSave
        vc!.userCart = userCart
        vc!.userCartList = userCartList
        self.navigationController?.pushViewController (vc!, animated: true)
    }
    
    func customNotesAdd(){
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
        let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromoCodeVC") as? PromoCodeVC
        vc!.delegate = self
        self.navigationController?.pushViewController (vc!, animated: true)
    }
}

extension CartVC : UITableViewDelegate,UITableViewDataSource , addressSelectionDelegate , CustomNotesAdd , promocodeDelegates{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
             return Cell
         case 2:
             let Cell = tableView.dequeueReusableCell(withIdentifier: "CartNoteCell") as! CartNoteCell
             Cell.noteDelegate = self
             Cell.lblNote.text = orderSave.note
             return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CartDetailsCell") as! CartDetailsCell
            if self.userCart != nil && (self.userCart?.count)! > 0 {
                Cell.initializeCellDetails(cellDic: userCartList , orderDetails : orderSave)
            }
            Cell.promocodeDelegate = self
            return Cell
        case 4:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "CartAddressCell") as! CartAddressCell
            Cell.delegate = self
            if orderSave.user_address_id != nil {
                Cell.btnCOntiniueAction.isHidden = false
                Cell.lblAddress.text = orderSave.user_address
            }else{
                Cell.btnCOntiniueAction.isHidden = true
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
            return 330
        case 4:
            return 120
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
