//
//  RegisterVC.swift
//  Tango
//
//  Created by Samir Samanta on 05/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var tbRegister: UITableView!
    var regisObj = RegisterModel()
    
    lazy var viewModel: SignUpVM = {
        return SignUpVM()
    }()
    var phoneNumbr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViewModel()
        self.tbRegister.delegate = self
        self.tbRegister.dataSource = self
        self.tbRegister.register(UINib(nibName: "LoginCommonCell", bundle: Bundle.main), forCellReuseIdentifier: "LoginCommonCell")
        self.tbRegister.register(UINib(nibName: "CommonButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "CommonButtonCell")
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
                
                if  (self?.viewModel.regisResponse.id) != nil {
                    self!.navigateTo()
                }else{
                    if self?.viewModel.regisResponse.msgPhone != nil {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.regisResponse.msgPhone![0])!, okButtonText: okText, completion: nil)
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                    }
                }
            }
        }
    }
    
    func navigateTo(){
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func loginRegisttration(){
        
        let param = RegisterParam()
        param.phone = phoneNumbr!
        param.name = regisObj.name
        param.email = regisObj.email
//        param.phone = regisObj.phone
        param.password = regisObj.password
        param.password_confirmation = regisObj.password_confirmation
        viewModel.sendRegisterCredentialsToAPIService(user: param)
    }
}

extension RegisterVC : UITableViewDelegate, UITableViewDataSource , CommonButtonAction {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = regisObj.name
            Cell.txtField.placeholder = "Name"
            Cell.txtField.keyboardType = .default
            Cell.txtField.isSecureTextEntry = false
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 0
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = regisObj.email
            Cell.txtField.placeholder = "Email"
            Cell.txtField.keyboardType = .emailAddress
            Cell.txtField.isSecureTextEntry = false
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 0
            Cell.imgIcon.image = UIImage(named: "mail56")
            return Cell
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = regisObj.password
            Cell.txtField.placeholder = "Password"
            Cell.txtField.keyboardType = .default
            Cell.txtField.isSecureTextEntry = true
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 0
            Cell.imgIcon.image = UIImage(named: "passwordIcon")
            return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = regisObj.password_confirmation
            Cell.txtField.placeholder = "Confirm Password"
            Cell.txtField.keyboardType = .default
            Cell.txtField.isSecureTextEntry = true
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 0
            Cell.imgIcon.image = UIImage(named: "passwordIcon")
            return Cell
        case 4:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonCell") as! CommonButtonCell
            buttonCell.btnCommonOutlet.setTitle("REGISTER", for: .normal)
            buttonCell.delegate = self
            return buttonCell
       
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
         case 0...3:
             return 65
         case 4:
             return 70
         default:
             return 0
         }
    }
}
extension RegisterVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
            case 0:
                regisObj.name = updateText as String
            case 1:
                regisObj.email = updateText as String
            case 2:
                regisObj.password = updateText as String
            case 3:
                regisObj.password_confirmation = updateText as String
            default:
                break
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
