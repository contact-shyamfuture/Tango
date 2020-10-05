//
//  LoginVC.swift
//  Tango
//
//  Created by Samir Samanta on 05/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import CoreLocation
import CoreTelephony

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginTableView: UITableView!
    lazy var viewModel: SignUpVM = {
        return SignUpVM()
    }()
    var loginObj = LoginParam()
    var saveObj = LoginModel()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginTableView.delegate = self
        self.loginTableView.dataSource = self
        self.loginTableView.register(UINib(nibName: "LoginCommonCell", bundle: Bundle.main), forCellReuseIdentifier: "LoginCommonCell")
        self.loginTableView.register(UINib(nibName: "CommonButtonCell", bundle: Bundle.main), forCellReuseIdentifier: "CommonButtonCell")
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // navigationController?.setNavigationBarHidden(true, animated: animated)
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            let s = flag(country: countryCode)
            print(s)
        }
        
        let networkInfo = CTTelephonyNetworkInfo()

        if let carrier = networkInfo.subscriberCellularProvider {
            print("country code is: " + carrier.mobileCountryCode!);

            //will return the actual country code
            print("ISO country code is: " + carrier.isoCountryCode!);
        }
    }
    
    func getFlag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    func loginAction(){
        if saveObj.username != nil {
            loginObj.username = self.saveObj.countryCode! + saveObj.username!
        }
        loginObj.password = saveObj.password
        loginObj.client_id = "2"
        loginObj.grant_type = "password"
        loginObj.client_secret = "aMRXNeDgf8kq9izvggI3gAykX0cu46mAJIXN6w2j"
        viewModel.sendLoginCredentialsToAPIService(user: loginObj)
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
                
                if  (self?.viewModel.userDetails.token_type) != nil {
                    
                    AppPreferenceService.setInteger(IS_LOGGED_IN, key: PreferencesKeys.loggedInStatus)
                    
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.access_token)!), key: PreferencesKeys.userAccessToken)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.refresh_token)!), key: PreferencesKeys.userrefreshToken)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.token_type!)!), key: PreferencesKeys.userTokentype)
                    
                    
                    let mainView = UIStoryboard(name:"Dashboard", bundle: nil)
                    let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                    self?.navigationController?.pushViewController (viewcontroller, animated: true)
                    
                }else{
                    
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.messag)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnFacebookLoginAction(_ sender: Any) {
    }
    
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "RegisterWithMobileVC") as! RegisterWithMobileVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    
    @IBAction func btnForgotAction(_ sender: Any) {
        let mainView = UIStoryboard(name:"Main", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
    }
    
    func loginRegisttration(){
        loginAction()
    }
}

extension LoginVC : UITableViewDelegate, UITableViewDataSource  , CommonButtonAction{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = saveObj.username
            Cell.txtField.placeholder = "Mobile number"
            Cell.txtField.keyboardType = .numberPad
            Cell.txtField.isSecureTextEntry = false
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 25
            if saveObj.coutryFlag != nil {
                Cell.imgIcon.image = saveObj.coutryFlag!.image()
            }
            Cell.lblCountryCode.text = saveObj.countryCode
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "LoginCommonCell") as! LoginCommonCell
            Cell.txtField.text = saveObj.password
            Cell.txtField.placeholder = "Password"
            Cell.txtField.keyboardType = .default
            Cell.txtField.isSecureTextEntry = true
            Cell.txtField.tag = indexPath.row
            Cell.txtField.delegate = self
            Cell.codeConstraint.constant = 0
            Cell.imgIcon.image = UIImage(named: "passwordIcon")
            return Cell
        case 2:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonCell") as! CommonButtonCell
            buttonCell.btnCommonOutlet.setTitle("SIGN IN", for: .normal)
            buttonCell.delegate = self
            return buttonCell
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
            case 0:
                saveObj.username = updateText as String
            case 1:
                saveObj.password = updateText as String
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

extension LoginVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        getAddressFromLatLon(pdblLatitude: locValue.latitude, pdblLongitude: locValue.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks {
                    if pm.count > 0 {
                          let pm = placemarks![0]
                         
                          var addressString : String = ""
                          if pm.subLocality != nil {
                              addressString = addressString + pm.subLocality! + ", "
                          }
                          if pm.thoroughfare != nil {
                              addressString = addressString + pm.thoroughfare! + ", "
                          }
                          if pm.locality != nil {
                              addressString = addressString + pm.locality! + ", "
                          }
                          if pm.country != nil {
                              addressString = addressString + pm.country! + ", "
                              //self.hostMatchObj.gameCountry = pm.country!
                             // self.lblCountry.text = pm.country!
                             // self.paramObj.country = pm.country!
                          }
                          if pm.postalCode != nil {
                              addressString = addressString + pm.postalCode! + " "
                          }
                          print(addressString)
                        let phoneCode = LoginVC.getCountryPhonceCode(pm.isoCountryCode!)
                        print(phoneCode)
                        self.saveObj.countryCode = "+" + phoneCode
                        
                        let s = self.flag(country: pm.isoCountryCode!)
                        print(s)
                        self.saveObj.coutryFlag = s
                        self.loginTableView.reloadData()
                    }
                }
        })
    }
    
    func flag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    class func getCountryPhonceCode (_ country : String) -> String
    {
        let countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if let countryCode = countryDictionary[country] {
            return countryCode
        }
        return ""
    }
}
extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
