//
//  DeliveryDetailsVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 16/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
struct OrderOptions {
    var title : String,description : String
    static func addData() -> [OrderOptions]{
        return[OrderOptions(title: "Order Placed", description: "We have received your order."),
        OrderOptions(title: "Order Confirmed", description: "Your order has been confirmed"),
        OrderOptions(title: "Oder Processed", description: "Yoour food is getting cooked"),
        OrderOptions(title: "Order Pickup", description: "your order is on its away"),
        OrderOptions(title: "Order Delivered", description: "Enjoy your meal"),
        ]
    }
}
class DeliveryDetailsVC: BaseViewController {

    //properties outlet
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tblFooterVw: UIView!
    @IBOutlet weak var lblOrderId : UILabel!
    @IBOutlet weak var lblNoItem : UILabel!
    @IBOutlet var disputePopUpView: UIView!
    
    //Dispute PopUp outlet
    @IBOutlet weak var lblDisputePopUpOrderID: UILabel!
    @IBOutlet weak var lblDisputePopUpCategory: UILabel!
    @IBOutlet weak var txtFldDisputePopUpStatus: UITextField!
    @IBOutlet weak var txtVwComplainDesc: UITextView!
    
    //Cancel PopUp Outlet
    @IBOutlet var vwCancelPopUp: UIView!
    @IBOutlet weak var lblCancelPopupOrderID: UILabel!
    @IBOutlet weak var txtVwCancelReason: UITextView!
    
    
    var complainedList = ["COMPLAINED","CANCELED","REFUND"]
    var selectedComplained = "COMPLAINED"
    var sectionCount = Int()
    
    lazy var viewModel: DeliveryDetailsVM = {
        return DeliveryDetailsVM()
    }()
    var itemscart = [ProfileCartModel]()
    var orderID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initializeViewModel()
        viewModel.getAddressList(id: orderID)
    }
    private func configureUI(){
       // topHeaderSet(vc: self)
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        sectionCount = 5
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.register(DeliveryDetailsMapCell.nib(), forCellReuseIdentifier: DeliveryDetailsMapCell.identifier)
        tblVw.register(DeliveryConfirmationListCell.nib(), forCellReuseIdentifier: DeliveryConfirmationListCell.identifier)
        tblVw.register(DeliveryInformationCell.nib(), forCellReuseIdentifier: DeliveryInformationCell.identifier)
        tblVw.register(DeliveryDetailsListingCell.nib(), forCellReuseIdentifier: DeliveryDetailsListingCell.identifier)
        tblVw.register(DeliveryDetailsPriceCell.nib(), forCellReuseIdentifier: DeliveryDetailsPriceCell.identifier)
        
        txtFldDisputePopUpStatus.delegate = self
        txtVwCancelReason.delegate = self
        txtVwCancelReason.text = "Enter your reason ?"
        txtVwCancelReason.textColor = UIColor.lightGray
        txtVwComplainDesc.delegate = self
        txtVwComplainDesc.text = "Enter Dispute Description.."
        txtVwComplainDesc.textColor = UIColor.lightGray
    }
    
    func btnInformationShow(tapBtn : String){
        sectionCount = tapBtn == "OrderDetails" ? 5 : 3
        if sectionCount == 5{
            tblFooterVw.frame = CGRect(x: 0, y: 0, width: tblVw.layer.bounds.width, height: 0)
        }else{
            tblFooterVw.frame = CGRect(x: 0, y: 0, width: tblVw.layer.bounds.width, height: 125)
        }
        tblVw.tableFooterView = tblFooterVw
        tblVw.reloadData()
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
                self?.lblOrderId.text = "Order ID : #\(self?.viewModel.orderDetails.id ?? 0)"
                let quantity = self?.viewModel.orderDetails.invoiceDetails?.quantity
                let totalPrice = self?.viewModel.orderDetails.invoiceDetails?.payable
                self?.lblNoItem.text = "\(quantity ?? 0)Item, ₹\(totalPrice ?? 0)"
                self?.itemscart = self?.viewModel.orderDetails.userCart ?? []
                self?.tblVw.reloadData()
            }
        }
        viewModel.refreshOrderDisputeViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                print(self?.viewModel.orderDispute.id)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        viewModel.refreshOrderCancelViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                print(self?.viewModel.orderCancel.id)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    @IBAction func disputeItemAction(_ sender: UIButton) {
        self.lblDisputePopUpOrderID.text = self.lblOrderId.text
        disputePopUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(disputePopUpView)
    }
    @IBAction func disputePopUpCancelAction(_ sender: UIButton) {
        disputePopUpView.removeFromSuperview()
    }
    @IBAction func disputePopUpSubmitAction(_ sender: UIButton) {
        if txtVwComplainDesc.text == "" || txtVwComplainDesc.text == "Enter Dispute Description.."{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please write some description", okButtonText: okText, completion: nil)
        }else{
            let param : [String : Any] = [
                "created_to" : "\(self.viewModel.orderDetails.user_id ?? 0)",
                "created_by" : "\(self.viewModel.orderDetails.user_id ?? 0)",
                "dispute_type" : selectedComplained,
                "description" : txtVwComplainDesc.text!,
                "order_id" : "\(self.viewModel.orderDetails.id ?? 0)",
                "status" : self.viewModel.orderDetails.status ?? ""
            ]
            self.viewModel.getOrderDisputeResponse(params: param)
        }
        
    }
    
    @IBAction func chatUsAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "Other", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatUsVC") as? ChatUsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnCancelOrderAction(_ sender: UIButton) {
        self.lblCancelPopupOrderID.text = self.lblOrderId.text
        vwCancelPopUp.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(vwCancelPopUp)
    }
    @IBAction func btnCancelPopUpACtion(_ sender: UIButton) {
        vwCancelPopUp.removeFromSuperview()
    }
    @IBAction func btnSubmitCancelOrderAction(_ sender: UIButton) {
        if txtVwCancelReason.text == "" || txtVwCancelReason.text == "Enter your reason ?"{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please write some reason for cancellation", okButtonText: okText, completion: nil)
        }else{
            let orderId = self.viewModel.orderDetails.id ?? 0
            self.viewModel.getOrderCancel(id: "\(orderId)", reasondesc: txtVwCancelReason.text!)
        }
        
    }
    
    
}
extension DeliveryDetailsVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 5
        }else if section == 3{
            return self.itemscart.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailsMapCell.identifier) as! DeliveryDetailsMapCell
            if let address = self.viewModel.orderDetails.address{
                Cell.setUpdatedLocation(with: address)
            }
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: DeliveryConfirmationListCell.identifier) as! DeliveryConfirmationListCell
            
            Cell.lblTitle.text = OrderOptions.addData()[indexPath.row].title
            Cell.lblDescription.text = OrderOptions.addData()[indexPath.row].description
            
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: DeliveryInformationCell.identifier) as! DeliveryInformationCell
            Cell.tapBtnClosure = { str in
                self.btnInformationShow(tapBtn: str)
            }
            return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailsListingCell.identifier) as! DeliveryDetailsListingCell
            let item = self.itemscart[indexPath.row]
            Cell.cellConfigUI(with: item)
            return Cell
        case 4:
            let Cell = tableView.dequeueReusableCell(withIdentifier: DeliveryDetailsPriceCell.identifier) as! DeliveryDetailsPriceCell
            if let invoicelist = self.viewModel.orderDetails.invoiceDetails {
                Cell.cellConfigUI(with: invoicelist)
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
            return 250
        case 1:
            return UITableView.automaticDimension
        case 2:
            return 44
        case 3:
            return 65
        case 4:
            return 240
        default:
            return 44
        }
    }
}

extension DeliveryDetailsVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0.7732977271, green: 0.1621543765, blue: 0, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textView == txtVwCancelReason ? "Enter your reason ?" : "Enter Dispute Description.."
            textView.textColor = UIColor.lightGray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let txtAfterUpdate = textView.text! as NSString
//        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as String
//        print("Updated TextField:: \(updateText)")
//
        let txtAfterUpdate = textView.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
        print("Updated TextField:: \(updateText)")
        
//        if textView == txtVwCancelReason{
//            txtVwCancelReason.text = updateText as String
//        }else{
//            txtVwComplainDesc.text = updateText as String
//        }
        
        
        
        return true
    }
}

extension DeliveryDetailsVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createPickerView(textfld : textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func createPickerView(textfld : UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        textfld.inputView = pickerView
        dismissPickerView(textfld: textfld)
    }
    
    func dismissPickerView(textfld : UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        vw.frame = toolBar.frame
        let cancelBtn = UIButton()
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.setTitleColor(#colorLiteral(red: 0.796983242, green: 0.08139943331, blue: 0.4261482358, alpha: 1), for: .normal)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        let doneBtn = UIButton()
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(#colorLiteral(red: 0.796983242, green: 0.08139943331, blue: 0.4261482358, alpha: 1), for: .normal)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.addTarget(self, action: #selector(self.action), for: .touchUpInside)
        vw.addSubview(cancelBtn)
        vw.addSubview(doneBtn)
        cancelBtn.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 8).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: vw.frame.height).isActive = true
        doneBtn.trailingAnchor.constraint(equalTo: vw.trailingAnchor, constant: -8).isActive = true
        doneBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: vw.frame.height).isActive = true
        textfld.inputAccessoryView = vw
    }
    
    @objc func cancel() {
        view.endEditing(true)
    }
    @objc func action() {
        view.endEditing(true)
        self.txtFldDisputePopUpStatus.text = selectedComplained
    }
}
//PickerView delegate and dataSource
extension DeliveryDetailsVC : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return complainedList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return complainedList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedComplained = complainedList[row]
    }
}
