//
//  PaymentVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import PayUCustomBrowser
import PlugNPlay
import CommonCrypto

class PaymentVC: BaseViewController {
    
    @IBOutlet weak var processingView: UIView!
    //properties outlet
    @IBOutlet weak var tblVw : UITableView!
    var sectionArray : [String] = ["Pay ONLINE","PAY ON DELIVERY"]
    lazy var viewModel: PaymentVM = {
        return PaymentVM()
    }()
    var orderDetails = OrderDetailsModel()
    var paymentType = PaymentSavedModel()
    
    var orderSave = OrderSaveModel()
    var userCart : [ProfileCartModel]?
    var userCartList = UserCartModel()
    
    lazy var viewprofileModel: DashboardVM = {
        return DashboardVM()
    }()
    var userdetails = ProfiledetailsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        //UINavigationBar.appearance().barTintColor = UIColor(red: 255/255.0, green: 167/255.0, blue: 0/255.0, alpha: CGFloat(1))
        processingView.isHidden = true
        initializeViewModel()
        initializeprofileViewModel()
        viewprofileModel.getProfileDetailsAPIService(device_type: "jdshjaksds", device_token: "kdsbkfbjksbk", device_id: "nsbdbsmn")
    }
    
    func initializeprofileViewModel() {
        viewprofileModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewprofileModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewprofileModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewprofileModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewprofileModel.refreshprofileViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewprofileModel.userdetails.id) != nil {
                    self?.userdetails = (self?.viewprofileModel.userdetails)!
                    print(self!.userdetails.id!)
                    
                    
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    private func configureUI(){
       // topHeaderSet(vc: self)
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.register(PaymentViewCell.nib(), forCellReuseIdentifier: PaymentViewCell.identifier)
    }
    
    @IBAction func btnProcedToPay(_ sender: Any) {
        let param = OrderParam()
        param.note = orderSave.note
        param.payment_mode = "cash"
        param.wallet = String(orderSave.wallet)
        param.delivery_charge = String(userCartList.delivery_charges!)
        param.packaging_charge = String(userCartList.packaging_charge!)
        param.user_address_id = String(orderSave.user_address_id!)
        param.tips_amount =  String(orderSave.tips_amount)
        viewModel.postOrderToAPIService(user: param)
    }
    func orderOnline(paymet_status : String , paymetID : String){
        
        let param = OrderParam()
        param.note = orderSave.note
        param.payment_mode = "payu"
        param.wallet = String(orderSave.wallet)
        param.delivery_charge = String(userCartList.delivery_charges!)
        param.packaging_charge = String(userCartList.packaging_charge!)
        param.user_address_id = String(orderSave.user_address_id!)
        param.tips_amount =  String(orderSave.tips_amount)
        param.payment_id = paymetID
        param.paymet_status = paymet_status
        viewModel.postOrderToAPIService(user: param)
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
                
                if  (self?.viewModel.orderDetails.id) != nil {
                    self?.orderDetails = (self?.viewModel.orderDetails)!
                    let mainView = UIStoryboard(name:"Other", bundle: nil)
                    let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
                    self?.navigationController?.pushViewController (viewcontroller, animated: true)
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func selectOption(index : Int){
        switch index {
        case 1:
            paymentType.isOnline = "Online"
            paymentType.isGooglePay = ""
            paymentType.isCash = ""
            processingView.isHidden = true
            payuNavigationHashKeyGeneration()
        case 2:
            paymentType.isCash = ""
            paymentType.isOnline = ""
            paymentType.isGooglePay = "Google Pay"
            processingView.isHidden = true
        case 3:
            paymentType.isGooglePay = ""
            paymentType.isOnline = ""
            paymentType.isCash = "Cash"
            processingView.isHidden = false
        default:
            break
        }
        tblVw.reloadData()
    }
    
    func payuNavigationHashKeyGeneration(){
        let txnId =  "Tango" + String(Int.random(in: 1...100)) + ""
        print("txnId==>\(txnId)")
        let paymentParams = PUMTxnParam()
        paymentParams.key = "266Medoj"
        paymentParams.merchantid = "6891096"
        paymentParams.txnID = txnId
        paymentParams.amount = "\(orderSave.totalAmount)"
        paymentParams.productInfo = "Tango"
        paymentParams.firstname = userdetails.name
        paymentParams.email = userdetails.email
        paymentParams.phone = userdetails.phone
        paymentParams.environment = PUMEnvironment.test
        paymentParams.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php"
        paymentParams.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php"
        paymentParams.udf1 = "udf1"
        paymentParams.udf2 = "udf2"
        paymentParams.udf3 = "udf3"
        paymentParams.udf4 = "udf4"
        paymentParams.udf5 = "udf5"
        paymentParams.udf6 = ""
        paymentParams.udf7 = ""
        paymentParams.udf8 = ""
        paymentParams.udf9 = ""
        paymentParams.udf10 = ""
        paymentParams.hashValue = self.getHashForPaymentParams(paymentParams)
        
        PlugNPlay.presentPaymentViewController(withTxnParams: paymentParams, on: self, withCompletionBlock: { paymentResponse, error, extraParam in
            if error != nil {
                print("Success==>\(error?.localizedDescription)")
            } else {
                var message = ""
                if paymentResponse?["result"] != nil && (paymentResponse?["result"] is [AnyHashable : Any]) {
                    print(paymentResponse!)
                    let resultDic = paymentResponse!["result"] as! Dictionary<String,Any>
                    let payemtnID = resultDic["paymentId"] as? Int ?? 0
                    let payemtnStatus = resultDic["status"] as? String ?? ""
                    self.orderOnline(paymet_status: payemtnStatus , paymetID: "\(payemtnID)")
                } else {
                    message = paymentResponse?["status"] as? String ?? ""
                }
                 print("Success==>\(message)")
            }
        })
    }
    
    func getHashForPaymentParams(_ txnParam: PUMTxnParam?) -> String? {
        let salt = "Q2oX5MqAdn"
        var hashSequence: String? = nil
        if let key = txnParam?.key, let txnID = txnParam?.txnID, let amount = txnParam?.amount, let productInfo = txnParam?.productInfo, let firstname = txnParam?.firstname, let email = txnParam?.email, let udf1 = txnParam?.udf1, let udf2 = txnParam?.udf2, let udf3 = txnParam?.udf3, let udf4 = txnParam?.udf4, let udf5 = txnParam?.udf5, let udf6 = txnParam?.udf6, let udf7 = txnParam?.udf7, let udf8 = txnParam?.udf8, let udf9 = txnParam?.udf9, let udf10 = txnParam?.udf10
        {
            print("key==>\(key)")
            hashSequence = "\(key)|\(txnID)|\(amount)|\(productInfo)|\(firstname)|\(email)|\(udf1)|\(udf2)|\(udf3)|\(udf4)|\(udf5)|\(udf6)|\(udf7)|\(udf8)|\(udf9)|\(udf10)|\(salt)"
            
            print("hashSequence==>\(hashSequence)")
        }
        let hash = self.sha512(hashSequence!).description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        print("hash==>\(hash)")
        return hash
    }
        

    func sha512(_ str: String) -> String {
        let data = str.data(using:.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
}

extension PaymentVC : UITableViewDelegate,UITableViewDataSource , selectPaymentOption{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionVw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.layer.bounds.width, height: 60))
        let topBorderLbl = UILabel(frame: CGRect(x: 0, y: 0, width: sectionVw.layer.bounds.width, height: 1))
        let bottomBorderLbl = UILabel(frame: CGRect(x: 0, y: sectionVw.layer.bounds.height - 1, width: sectionVw.layer.bounds.width, height: 1))
        let titleLbl = UILabel(frame: CGRect(x: 5, y: 0, width: sectionVw.layer.bounds.width - 10, height: sectionVw.layer.bounds.height))
        titleLbl.text = sectionArray[section]
        titleLbl.textColor = .black
        topBorderLbl.backgroundColor = .lightGray
        bottomBorderLbl.backgroundColor = .lightGray
        sectionVw.addSubview(topBorderLbl)
        sectionVw.addSubview(bottomBorderLbl)
        sectionVw.addSubview(titleLbl)
        sectionVw.backgroundColor = UIColor.init(displayP3Red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        return sectionVw
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblVw.dequeueReusableCell(withIdentifier: PaymentViewCell.identifier, for: indexPath) as? PaymentViewCell
        
            else {return UITableViewCell()}
        if indexPath.section == 0 {
            cell.btnCheck.isHidden = true
            switch indexPath.row {
            case 0:
                cell.btnCheck.tag = 1
                if paymentType.isOnline == "Online" {
                    cell.btnCheck.isSelected = true
                }else{
                    cell.btnCheck.isSelected = false
                }
                cell.imgIcon.image = UIImage(named: "onliePayment")
                cell.lblOptionName.text = "Make payment through online"
            case 1:
                if paymentType.isGooglePay == "Google Pay" {
                    cell.btnCheck.isSelected = true
                }else{
                    cell.btnCheck.isSelected = false
                }
                cell.imgIcon.image = UIImage(named: "googlepay")
                cell.btnCheck.tag = 2
                cell.lblOptionName.text = "Google Pay"
            default:
                cell.btnCheck.tag = 0
                cell.lblOptionName.text = ""
            }
        }else{
            cell.imgIcon.image = UIImage(named: "cash")
            cell.btnCheck.isHidden = false
            if paymentType.isCash == "Cash" {
                cell.btnCheck.isSelected = true
            }else{
                cell.btnCheck.isSelected = false
            }
            cell.btnCheck.tag = 3
            cell.lblOptionName.text = "By cash"
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                selectOption(index : 1)
            }else{
                selectOption(index : 2)
            }
        }else{
            selectOption(index : 3)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
