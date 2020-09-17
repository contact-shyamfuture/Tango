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

class DashboardVC: BaseViewController {
    @IBOutlet weak var lbNearLocation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var dashboradTableView: UITableView!
    var obj = UserResponse()
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var userdetails = ProfiledetailsModel()
    var resObj : RestaurantModel?
    var shopList : [RestaurantList]?
    var topBanner = [TopBannerModel]()
    var safetyBanner = [SafetyModel]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.btnBackAction.isHidden = true
        self.dashboradTableView.delegate = self
        self.dashboradTableView.dataSource = self
        self.dashboradTableView.register(UINib(nibName: "SliderCell", bundle: Bundle.main), forCellReuseIdentifier: "SliderCell")
        self.dashboradTableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "ItemCell")
        
        self.dashboradTableView.register(UINib(nibName: "SafetyCellT", bundle: Bundle.main), forCellReuseIdentifier: "SafetyCellT")
        
        //print(obj.access_token!)
        initializeViewModel()
        getprifleDetails()
        //getDashboardList()
        
        self.tabBarView.imgArray = ["HomeSelected","Search","finished","Profile"]
        self.tabBarView.uiColorArray = [UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1))]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        getTopBanner()
        getSafetyBanner()
    }
    
    func getDashboardList(){
        viewModel.getDashboardToAPIService(lat: "", long: "", id: "")
    }
    
    func getTopBanner(){
        viewModel.getTopBannerAPIService()
    }
    
    func getSafetyBanner(){
        viewModel.getSafetyBannerAPIService()
    }
    
    func getprifleDetails(){
        viewModel.getProfileDetailsAPIService(device_type: "jdshjaksds", device_token: "kdsbkfbjksbk", device_id: "nsbdbsmn")
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
                    self?.shopList = self?.viewModel.restaurantModel.shopList
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
                    self?.topBanner = (self?.viewModel.topBanner)!
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
        
        
    }
}

extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            if self.shopList != nil && self.shopList!.count > 0 {
                return self.shopList!.count
            }else{
                return 0
            }
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SliderCell") as! SliderCell
            Cell.initializeCellDetails(cellDic: topBanner)
            return Cell
        }else if indexPath.section == 1{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SafetyCellT") as! SafetyCellT
            Cell.initializeCellDetails(cellDic: safetyBanner)
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
            Cell.initializeCellDetails(cellDic: self.shopList![indexPath.row])
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        if section == 0 {
            label.text = ""
        }else if section == 1 {
            label.text = "MEASURES TO ENSURE SAFETY"
        }else{
            if resObj != nil {
                label.text = "\(resObj!.total_shops ?? 0) Restaurants near you within \(resObj!.nearby_distance ?? "")"
            }else{
                label.text = " "
            }
        }
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.red // my custom colour
        headerView.backgroundColor = .white

        headerView.addSubview(label)

        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }else {
            return 210
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "RestourantMenuListVC") as? RestourantMenuListVC
            vc!.categoryList = self.shopList![indexPath.row]
            vc!.userdetails = userdetails
            self.navigationController?.pushViewController (vc!, animated: true)
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
        viewModel.getDashboardToAPIService(lat: "\(pdblLatitude)", long: "\(pdblLongitude)", id: "")
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
                            self.lbNearLocation.text = addressString
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