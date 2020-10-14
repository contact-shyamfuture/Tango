//
//  DashboardVC.swift
//  Tango
//
//  Created by Samir Samanta on 03/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import CoreLocation
import CoreTelephony
import Foundation

class DashboardVC: BaseViewController , filterValuesDelegates , UIScrollViewDelegate , DeliveryLocationSaved{
    @IBOutlet weak var lbNearLocation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var dashboradTableView: UITableView!
    var obj = UserResponse()
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var userdetails = ProfiledetailsModel()
    var resObj : RestaurantModel?
    var resObj2 : RestaurantNearModel?
    var shopList = [RestaurantList]()
    var shopNearList = [RestaurantList]()
    var topBanner = [TopBannerModel]()
    var safetyBanner = [SafetyModel]()
    var locationManager = CLLocationManager()
    var offset : String = "0"
    var totalCount : Int?
    var perPage : Int?
    var latValue : Double?
    var longValue : Double?
    
    @IBOutlet weak var tableViewFooter: UIView!
    var promoList = [PromoCodeModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.btnHeartOutlet.isHidden = true
        headerView.isHidden = true
        
        headerView.btnBackAction.isHidden = true
        self.dashboradTableView.delegate = self
        self.dashboradTableView.dataSource = self
        self.dashboradTableView.register(UINib(nibName: "SliderCell", bundle: Bundle.main), forCellReuseIdentifier: "SliderCell")
        self.dashboradTableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemCell")
        
        self.dashboradTableView.register(UINib(nibName: "SafetyCellT", bundle: Bundle.main), forCellReuseIdentifier: "SafetyCellT")
        self.dashboradTableView.register(UINib(nibName: "DashboardHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "DashboardHeaderCell")
        
        self.dashboradTableView.register(UINib(nibName: "HeaderNearCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderNearCell")
        
        self.dashboradTableView.register(UINib(nibName: "DashboradPromocodeCell", bundle: Bundle.main), forCellReuseIdentifier: "DashboradPromocodeCell")
        
        //print(obj.access_token!)
        initializeViewModel()
        
        
        //getDashboardList()
        
        self.tabBarView.imgArray = ["HomeSelected","Search","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
        self.tableViewFooter.isHidden = true
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            getprifleDetails()
            getPromoDetails()
            getTopBanner()
            getSafetyBanner()
        }else{
            
        }
    }
    
    @IBAction func btnShareAction(_ sender: Any) {
        let myWebsite = NSURL(string:"https://play.google.com/store/apps/details?id=com.tangoeateries.customer&hl=en_US")
        let img : String = "Tango - Online Food Delivery App"

        guard let url = myWebsite else {
            print("nothing found")
            return
        }

        let shareItems:Array = [img, url] as [Any]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnChangeAddressAction(_ sender: Any) {
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            selectAddress()
        }else{
            commonAllertView()
        }
        
    }
    func commonAllertView(){
        let refreshAlert = UIAlertController(title: "Tango", message: "Do you need to login", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.openSignInViewController()
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
          
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func selectAddress(){
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC
        vc?.delegate = self
        vc?.isSelected = true
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func getDeliveryLocation(Address : String, addressID : Int , adddic : AddressListModel ){
        self.lblLocation.text = adddic.map_address
        self.lbNearLocation.text = adddic.type
        
        AppPreferenceService.setString(String((adddic.map_address)!), key: PreferencesKeys.mapAddress)
        AppPreferenceService.setString(String((adddic.type!)), key: PreferencesKeys.mapType)
        AppPreferenceService.setString(String((adddic.latitude!)), key: PreferencesKeys.mapLat)
        AppPreferenceService.setString(String((adddic.longitude!)), key: PreferencesKeys.mapLong)
        
        viewModel.getDashboardToAPIService(lat: "\(adddic.latitude ?? 0)", long: "\(adddic.longitude ?? 0)", id: "", offset: offset)
        
        viewModel.getDashboardNearByFalseToAPIService(lat: "\(adddic.latitude ?? 0)", long: "\(adddic.longitude ?? 0)", id: "", offset: offset)
    }
    
    func getDashboardList(){
        viewModel.getDashboardToAPIService(lat: "", long: "", id: "", offset: offset)
    }
    
    func getDashboardNearList(){
        viewModel.getDashboardNearByFalseToAPIService(lat: "", long: "", id: "", offset: offset)
    }
    
    func getTopBanner(){
        viewModel.getTopBannerAPIService()
    }
    
    func getSafetyBanner(){
        viewModel.getSafetyBannerAPIService()
    }
    
    func getprifleDetails(){
        let deviceToken = AppPreferenceService.getString(PreferencesKeys.FCMTokenDeviceID)
        let deviceID = getUUID()
        viewModel.getProfileDetailsAPIService(device_type: "ios", device_token: deviceToken!, device_id: deviceID!)
    }
    
    func getPromoDetails(){
        viewModel.getPromoListListAPIService()
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
                
                if  (self?.viewModel.restaurantModel.shopList) != nil {
                    self?.resObj = self?.viewModel.restaurantModel
                    self?.shopList += (self?.viewModel.restaurantModel.shopList)!
                    self?.dashboradTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshViewNearByClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.restaurantNearModel.shopList) != nil {
                    self?.resObj2 = self?.viewModel.restaurantNearModel
                    self?.shopNearList += (self?.viewModel.restaurantNearModel.shopList)!
                    self?.dashboradTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshprofileViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.userdetails.id) != nil {
                    self?.userdetails = (self?.viewModel.userdetails)!
                    print(self!.userdetails.id!)
                    
                    AppPreferenceService.setString(String((self!.userdetails.id!)), key: PreferencesKeys.userID)
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshToBannerViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.topBanner) != nil {
                    
                    if (self?.viewModel.topBanner.count)! > 0 {
                        self?.topBanner = (self?.viewModel.topBanner.filter {
                        $0.shopList!.offer_percent != 0
                        })!
                    }
                    self?.dashboradTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshSafetyBannerViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.safetyBanner) != nil {
                    self?.safetyBanner = (self?.viewModel.safetyBanner)!
                    self?.dashboradTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile", okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.refreshPromoListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.promoList) != nil {
                    self?.promoList = (self?.viewModel.promoList)!
                    self?.dashboradTableView.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "No promo code found", okButtonText: okText, completion: nil)
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
    
    @IBAction func btnFilterAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC
        vc!.filterDel = self
        self.navigationController?.pushViewController (vc!, animated: true)
    }
    
    func filterValues(value : String){
        viewModel.getDashboardToAPIService(lat: "\(latValue ?? 0)", long: "\(longValue ?? 0)", id: "", offset: offset)
        
        viewModel.getDashboardNearByFalseToAPIService(lat: "\(latValue ?? 0)", long: "\(longValue ?? 0)", id: "", offset: offset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY == contentHeight - scrollView.frame.size.height {
            self.tableViewFooter.isHidden = false
            if resObj!.total_shops != nil && shopList != nil {
                if resObj!.total_shops! > shopList.count {
                    viewModel.getDashboardToAPIService(lat: "\(latValue ?? 0)", long: "\(longValue ?? 0)", id: "", offset: "\(shopList.count)")
                } else {
                   self.tableViewFooter.isHidden = true
                }
            }else{
                self.tableViewFooter.isHidden = true
            }
        }
    }
    
    func navigateToSafetyDetails(id : Int){
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SafetyMesureVC") as? SafetyMesureVC
        vc!.id = "\(id)"
        self.navigationController?.pushViewController (vc!, animated: true)
    }
}

extension DashboardVC : UITableViewDelegate, UITableViewDataSource , safetyDetails{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2{
            if self.shopList != nil && self.shopList.count > 0 {
                return self.shopList.count
            }else{
                return 1
            }
        }else if section == 3{
            if self.shopNearList != nil && self.shopNearList.count > 0 {
                return self.shopNearList.count
            }else{
                return 0
            }
        }else{
            if self.promoList != nil && self.promoList.count > 0 {
                return 1//return self.promoList.count
            }else{
                return 0
            }
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SafetyCellT") as! SafetyCellT
            Cell.initializeCellDetails(cellDic: safetyBanner)
            Cell.delegateSft = self
            return Cell
            
        }else if indexPath.section == 1{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as! SliderCell
            Cell.initializeCellDetails(cellDic: topBanner)
            return Cell
        }else if indexPath.section == 2{
            if self.shopList != nil && self.shopList.count > 0 {
                let Cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
                Cell.noRestaurantImageView.isHidden = true
                Cell.initializeCellDetails(cellDic: self.shopList[indexPath.row])
                return Cell
            }else{
                let Cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
                Cell.noRestaurantImageView.isHidden = false
               // Cell.initializeCellDetails(cellDic: self.shopList[indexPath.row])
                return Cell
            }
            
            
        }else if indexPath.section == 3{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            Cell.initializeCellNearDetails(cellDic: self.shopNearList[indexPath.row])
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboradPromocodeCell") as! DashboradPromocodeCell
            Cell.initializeCellDetails(cellDic: promoList)
            return Cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//        let label = UILabel()
//        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//
//        if section == 0 {
//            label.text = ""
//        }else if section == 1 {
//            label.text = "MEASURES TO ENSURE SAFETY"
//        }else{
//            if resObj != nil {
//                label.text = "\(resObj!.total_shops ?? 0) Restaurants near you within \(resObj!.nearby_distance ?? "")"
//            }else{
//                label.text = " "
//            }
//        }
//        label.font = .systemFont(ofSize: 18) // my custom font
//        label.textColor = UIColor.red // my custom colour
//        headerView.backgroundColor = .white
//        headerView.addSubview(label)
//
//        let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
        switch section {
        case 0:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "MEASURES TO ENSURE SAFETY"
            return Cell
        case 1:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "TOP PICKS FOR YOU"
            return Cell
            
        case 2:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "RESTAURANTS"
            return Cell
        case 3:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "HeaderNearCell") as! HeaderNearCell
            if resObj2 != nil {
                Cell.lblHeaderName.text = "\(resObj2!.total_shops ?? 0) RESTAURANTS NEAR YOU WITH IN \(resObj2!.nearby_distance ?? "") (EXTRA CHARGES APPLICABLE)"
            }else{
                Cell.lblHeaderName.text = " RESTAURANTS NEAR YOU WITH IN 0 KM (EXTRA CHARGES APPLICABLE)"
            }
            return Cell
        case 4:
            let Cell = tableView.dequeueReusableCell(withIdentifier: "DashboardHeaderCell") as! DashboardHeaderCell
            Cell.lblTitle.text = "PROMO CODE"
            return Cell
        default:
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if safetyBanner != nil && safetyBanner.count > 0 {
                return 50
            }else{
                return 0
            }
            
        }else if section == 1{
            if topBanner != nil && topBanner.count > 0 {
                return 50
            }else{
                return 0
            }
        }else if section == 3 {
            if resObj2 != nil {
                if resObj2!.total_shops! > 0 {
                    return 70
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else if section == 4 {
            if promoList != nil && promoList.count > 0 {
                return 50
            }else{
                return 0
            }
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if topBanner != nil && topBanner.count > 0 {
                return 200
            }else{
                return 0
            }
        }else if indexPath.section == 0 {
            if safetyBanner != nil && safetyBanner.count > 0 {
                return 210
            }else{
                return 0
            }
        }else if indexPath.section == 4{
            return 150
        }else {
            return 210
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            if self.shopList[indexPath.row].shopstatus == "OPEN" {
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
                vc!.categoryList = self.shopList[indexPath.row]
                vc!.userdetails = userdetails
                vc!.shopID = "\(self.shopList[indexPath.row].id ?? 0)"
                self.navigationController?.pushViewController (vc!, animated: true)
            }else{
                self.showAlertWithSingleButton(title: commonAlertTitle, message: "Shop closed", okButtonText: okText, completion: nil)
            }
            
           /* let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
            vc!.categoryList = self.shopList[indexPath.row]
            vc!.userdetails = userdetails
            vc!.shopID = "\(self.shopList[indexPath.row].id ?? 0)"
            self.navigationController?.pushViewController (vc!, animated: true) */
        }
    }
}

extension DashboardVC : CLLocationManagerDelegate {

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
        latValue = pdblLatitude
        longValue = pdblLongitude
        
        if AppPreferenceService.getString(PreferencesKeys.mapLat) != nil {
            let mapLat = AppPreferenceService.getString(PreferencesKeys.mapLat)
            let mapLong = AppPreferenceService.getString(PreferencesKeys.mapLong)
            
            self.lblLocation.text = AppPreferenceService.getString(PreferencesKeys.mapAddress)
            self.lbNearLocation.text = AppPreferenceService.getString(PreferencesKeys.mapType)
            
            viewModel.getDashboardToAPIService(lat: "\(mapLat ?? "0")", long: "\(mapLong ?? "0")", id: "", offset: offset)
            
            viewModel.getDashboardNearByFalseToAPIService(lat: "\(mapLat ?? "0")", long: "\(mapLong ?? "0")", id: "", offset: offset)
        }else{
            viewModel.getDashboardToAPIService(lat: "\(pdblLatitude)", long: "\(pdblLongitude)", id: "", offset: offset)
            
            viewModel.getDashboardNearByFalseToAPIService(lat: "\(pdblLatitude)", long: "\(pdblLongitude)", id: "", offset: offset)
            
            //getDashboardNearList()
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
                                self.lbNearLocation.text = pm.thoroughfare!
                              }
                              if pm.locality != nil {
                                  addressString = addressString + pm.locality! + ", "
                               // self.lbNearLocation.text = pm.locality
                              }
                              if pm.country != nil {
                                  addressString = addressString + pm.country! + ", "
                              }
                              if pm.postalCode != nil {
                                  addressString = addressString + pm.postalCode! + " "
                              }
                            self.lblLocation.text = addressString
                              print(addressString)
                        }
                    }
            })
        }
    }
}
class KeychainAccess {

    func addKeychainData(itemKey: String, itemValue: String) throws {
        guard let valueData = itemValue.data(using: .utf8) else {
            print("Keychain: Unable to store data, invalid input - key: \(itemKey), value: \(itemValue)")
            return
        }

        //delete old value if stored first
        do {
            try deleteKeychainData(itemKey: itemKey)
        } catch {
            print("Keychain: nothing to delete...")
        }

        let queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecValueData as String: valueData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let resultCode: OSStatus = SecItemAdd(queryAdd as CFDictionary, nil)

        if resultCode != 0 {
            print("Keychain: value not added - Error: \(resultCode)")
        } else {
            print("Keychain: value added successfully")
        }
    }

    func deleteKeychainData(itemKey: String) throws {
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject
        ]

        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

        if resultCodeDelete != 0 {
            print("Keychain: unable to delete from keychain: \(resultCodeDelete)")
        } else {
            print("Keychain: successfully deleted item")
        }
    }

    func queryKeychainData (itemKey: String) throws -> String? {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCodeLoad != 0 {
            print("Keychain: unable to load data - \(resultCodeLoad)")
            return nil
        }

        guard let resultVal = result as? NSData, let keyValue = NSString(data: resultVal as Data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Keychain: error parsing keychain result - \(resultCodeLoad)")
            return nil
        }
        return keyValue
    }
}
