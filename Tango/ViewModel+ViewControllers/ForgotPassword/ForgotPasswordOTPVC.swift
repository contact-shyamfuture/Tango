//
//  ForgotPasswordOTPVC.swift
//  Tango
//
//  Created by Samir Samanta on 19/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import UIKit
import SVPinView

class ForgotPasswordOTPVC: UIViewController {

    @IBOutlet weak var otpView: SVPinView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var otpTableView: UITableView!
    var otpValue : Int?
    var pinValue : String?
    var phoneNumbr : String?
    var userID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.otpTableView.delegate = self
        self.otpTableView.dataSource = self
        self.lblPhoneNumber.text = phoneNumbr
        self.otpTableView.register(UINib(nibName: "CommonButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "CommonButtonCell")
        otpView.didFinishCallback = didFinishEnteringPin(pin:)
        otpView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    
    func loginRegisttration(){
      let data = String (otpValue!)
        if pinValue != nil && data == pinValue {
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotChangePasswordVC") as? ForgotChangePasswordVC
            vc?.phoneNumbr = self.phoneNumbr
            vc?.userID = self.userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            
        }
    }
    
    func didFinishEnteringPin(pin:String) {
           
        let data = String (otpValue!)
        if data == pin {
            pinValue = pin
        }else{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Otp does not match", okButtonText: okText, completion: {
                self.otpView.clearPin()
            })
        }
    }
    
    // MARK: Helper Functions
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setGradientBackground(view:UIView, colorTop:UIColor, colorBottom:UIColor) {
        for layer in view.layer.sublayers! {
            if layer.name == "gradientLayer" {
                layer.removeFromSuperlayer()
            }
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.name = "gradientLayer"
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    @IBAction func btnResendOtp(_ sender: Any) {
    }
    
}

extension ForgotPasswordOTPVC : UITableViewDelegate, UITableViewDataSource , CommonButtonAction {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonCell") as! CommonButtonCell
            buttonCell.delegate = self
            buttonCell.btnCommonOutlet.setTitle("CONTINUE", for: .normal)
            return buttonCell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
         case 0:
            return 70
         
         default:
             return 0
         }
    }
}
