//
//  AddressListVC.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddressListVC: BaseViewController {

    @IBOutlet weak var btnAddAddressOutlet: UIButton!
    @IBOutlet weak var tableAddressList: UITableView!
    var delegate : DeliveryLocationSaved?
    
    var lat : Double?
    var Long : Double?
    var address : String?
    let locationManager  = CLLocationManager()
    
    @IBOutlet weak var setDeliveryLocationView: UIView!
    lazy var viewModel: AddressListVM = {
        return AddressListVM()
    }()
    var addressList = [AddressListModel]()
    
    var isSelected :  Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.btnHeartOutlet.isHidden = true
        headerView.imgLogo.isHidden = true
        headerView.imgBackLogo.isHidden = false
        tabBarView.isHidden = true
        self.tableAddressList.delegate = self
        self.tableAddressList.dataSource = self
        self.tableAddressList.register(UINib(nibName: "AddressListCell", bundle: Bundle.main), forCellReuseIdentifier: "AddressListCell")
        if isSelected == true {
            btnAddAddressOutlet.isHidden = true
            setDeliveryLocationView.isHidden = false
        }else{
            setDeliveryLocationView.isHidden = true
        }
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ApiCalled()
    }
    
    private func ApiCalled(){
        viewModel.getAddressList()
    }
    
    @IBAction func btnSetDeliveryLocationBtnAction(_ sender: Any) {
        openGooglePlaceControllerView()
    }
    
    func openGooglePlaceControllerView()
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        UINavigationBar.appearance().tintColor = UIColor.white
        UISearchBar.appearance().barStyle = UIBarStyle.blackOpaque
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddAddress(_ sender: Any) {
        let mainView = UIStoryboard(name:"Other", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
        self.navigationController?.pushViewController (viewcontroller, animated: true)
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
                self?.addressList = self?.viewModel.addressList ?? []
                if (self?.addressList.count)! > 0{
                    self?.tableAddressList.reloadData()
                }
            }
        }
        
        viewModel.refreshDeleteViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if self?.viewModel.deleteAdd.message != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message:  (self?.viewModel.deleteAdd.message)!, okButtonText: okText, completion: {
                    
                        self!.ApiCalled()
                    })
                }
            }
        }
    }
    //9933326218
    
    func manageAddressDelete(index : Int){
        print("tap index path : \(index)")
        
        let refreshAlert = UIAlertController(title: "", message: "Do you want to delete?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.deleteAddressDetails(id: "\(self.addressList[index].id ?? 0)")
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
           
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func manageAddressEdit(index : Int){
        
       let dic = self.addressList[index]
        let vc = UIStoryboard.init(name: "Other", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryLocationVC") as? DeliveryLocationVC
        vc!.lat = dic.latitude
        vc!.Long = dic.longitude
        vc!.address = dic.map_address
        vc!.googlePlace = "Edit"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension AddressListVC : UITableViewDelegate, UITableViewDataSource  , manageAddress{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            if isSelected == true {
                return 1
            }else{
                return 0
            }
        }else {
            return self.addressList.count
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
            //Cell.btnStackVw.isHidden = true
            Cell.lblTitle.text = "Current Location"
            Cell.lblAddress.text = "Enable Location Service"
            if isSelected == true {
                Cell.editbtnOutlet.isHidden = true
                Cell.deleteBtnOutlet.isHidden = true
            }else{
                Cell.editbtnOutlet.isHidden = false
                Cell.deleteBtnOutlet.isHidden = false
            }
            return Cell
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
            
            let list = self.addressList[indexPath.row]
            //Cell.btnStackVw.isHidden = false
            Cell.lblTitle.text = list.type?.uppercased()
            if list.type?.uppercased() == "HOME" {
                Cell.imgType.image = UIImage(named: "Home")
            }else{
                Cell.imgType.image = UIImage(named: "location")
            }
            Cell.editbtnOutlet.tag = indexPath.row
            Cell.deleteBtnOutlet.tag = indexPath.row
            Cell.delegate = self
            Cell.lblAddress.text = list.map_address
            
            if isSelected == true {
                Cell.editbtnOutlet.isHidden = true
                Cell.deleteBtnOutlet.isHidden = true
            }else{
                Cell.editbtnOutlet.isHidden = false
                Cell.deleteBtnOutlet.isHidden = false
            }
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
        if section == 0 {
            label.text = ""
        }else {
            label.text = "SAVED ADDRESS"
        }
        label.font = .systemFont(ofSize: 18) // my custom font
        label.textColor = UIColor.gray // my custom colour
        headerView.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)

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
        //UITableView.automaticDimension
        if indexPath.section == 0 {
            if isSelected == true {
                return 100
            }else{
                return 0
            }
        }else{
            return 140//UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected == true {
            if indexPath.section == 0 {
                let mainView = UIStoryboard(name:"Other", bundle: nil)
                let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
                self.navigationController?.pushViewController (viewcontroller, animated: true)
            }else{
                navigationController?.popViewController(animated: true)
                delegate?.getDeliveryLocation(Address: self.addressList[indexPath.row].map_address!, addressID: self.addressList[indexPath.row].id!, adddic: self.addressList[indexPath.row])
            }
        }
    }
}
extension AddressListVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        //self.txtSearchLocationField.text = place.formattedAddress
       // lblAddress.text = place.formattedAddress
        address = place.formattedAddress
        
        let getLat: CLLocationDegrees = place.coordinate.latitude
        let getLng: CLLocationDegrees = place.coordinate.longitude
        lat = getLat
        Long = getLng
        
        let vc = UIStoryboard.init(name: "Other", bundle: Bundle.main).instantiateViewController(withIdentifier: "DeliveryLocationVC") as? DeliveryLocationVC
        vc!.lat = self.lat
        vc!.Long = self.Long
        vc!.address = self.address
        vc!.googlePlace = "Yes"
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        var street_number: String = ""
        var route: String = ""
        var neighborhood:String = ""
        var locality:String = ""
        var administrative_area_level_1 : String = ""
        var country : String = ""
        var postal_code : String = ""
        var postal_code_suffix :String = ""
        
        if let addressLines = place.addressComponents
        {
            for field in addressLines
            {
                switch field.type
                {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                    //AppPreferenceService.setString(locality, key: PreferencesKeys.userAddressCity)
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                   // AppPreferenceService.setString(administrative_area_level_1, key: PreferencesKeys.userAddressState)
                case kGMSPlaceTypeCountry:
                    country = field.name
                    //AppPreferenceService.setString(country, key: PreferencesKeys.userAddressCountry)
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                    //AppPreferenceService.setString(postal_code, key: PreferencesKeys.userAddressZip)
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                default:
                    break
                }
            }
        }
        
        
        
        //self.showCurrentLocationonMap(lat: getLat, long: getLng)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
