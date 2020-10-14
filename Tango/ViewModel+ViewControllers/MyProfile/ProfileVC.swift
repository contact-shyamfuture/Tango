//
//  ProfileVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 18/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

//Configure Data..
struct items {
    var title : String,img : String
    static func addData() -> [items]{
        return[items(title: "MANAGE ADDRESS", img: "Home"),
        items(title: "FAVOURITES", img: "favourite"),
        items(title: "PAYMENT", img: "payment"),
        items(title: "MY ORDER", img: "myoder"),
        items(title: "PROMOTION DETAILS", img: "promotiondetails"),
        items(title: "CHANGE PASSWORD", img: "passwordIcon")
        ]
    }
}

class ProfileVC: BaseViewController {

    //Outlet Properties..
    @IBOutlet weak var tblVw : UITableView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var userdetails = ProfiledetailsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       headerView.btnHeartOutlet.isHidden = true
        
        headerView.btnBackAction.isHidden = true
        headerView.imgBackLogo.isHidden = true
        userProfileImage.layer.borderWidth = 0
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.borderColor = UIColor.white.cgColor
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        userProfileImage.clipsToBounds = true
        
        configureUI()
        
        initializeViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getprifleDetails()
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
        
        viewModel.refreshprofileViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.userdetails.id) != nil {
                    self?.userdetails = (self?.viewModel.userdetails)!
                    print(self!.userdetails.id!)
                    self!.lblPhoneNumber.text = self!.userdetails.phone
                    self!.lblEmail.text = self!.userdetails.email
                    self!.lblUserName.text = self!.userdetails.name
                    if self!.userdetails.avatar != nil {
                        self!.userProfileImage.sd_setImage(with: URL(string: self!.userdetails.avatar!))
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
        tblVw.delegate = self
        tblVw.dataSource = self
        tblVw.register(ProfileSettingCell.nib(), forCellReuseIdentifier: ProfileSettingCell.identifier)
        self.tabBarView.imgArray = ["Home","Search","finished","Profile2Selected"]
        
        self.tabBarView.uiColorArray = [UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)),UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 67/255.0, green: 67/255.0, blue: 67/255.0, alpha: CGFloat(1)) , UIColor(red: 255/255.0, green: 133/255.0, blue: 0/255.0, alpha: CGFloat(1))]
        
        userProfileImage.layer.borderWidth = 0.5
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.borderColor = UIColor.lightGray.cgColor
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        userProfileImage.clipsToBounds = true
    }
    
    @IBAction func btnActionEdit(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileEditVC") as? ProfileEditVC
        vc?.userdetails = self.userdetails
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnLogOutAction(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
          }))

        refreshAlert.addAction(UIAlertAction(title: "YES", style: .cancel, handler: { (action: UIAlertAction!) in
           AppPreferenceService.setInteger(IS_LOGGED_OUT, key: PreferencesKeys.loggedInStatus)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openSignInViewController()
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}

extension ProfileVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.addData().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblVw.dequeueReusableCell(withIdentifier: ProfileSettingCell.identifier, for: indexPath) as? ProfileSettingCell else {
            return UITableViewCell()
        }
        cell.lblTitle.text = items.addData()[indexPath.row].title
        cell.imgVw.image = UIImage(named: items.addData()[indexPath.row].img)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tblVw.layer.bounds.width, height: tblVw.layer.bounds.height))
        let imgVw = UIImageView(frame: CGRect(x: 10, y: 12.5, width: 30, height: 30))
        imgVw.image = UIImage(named: "Profile")
        imgVw.contentMode = .scaleAspectFit
        let titleLbl = UILabel(frame: CGRect(x: imgVw.frame.width + 30, y: 3, width: tblVw.layer.bounds.width - 10, height: 50))
        
        imgVw.layer.borderWidth = 0.5
        imgVw.layer.masksToBounds = false
        imgVw.layer.borderColor = UIColor.lightGray.cgColor
        imgVw.layer.cornerRadius = imgVw.frame.size.width / 2
        imgVw.clipsToBounds = true
        
        titleLbl.text = "My Account"
        titleLbl.font = UIFont.init(name: "Roboto-Regular", size: 20)
        vw.backgroundColor = UIColor.white
        vw.addSubview(titleLbl)
        vw.addSubview(imgVw)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressListVC") as? AddressListVC
            vc?.isSelected = false
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouritesVC") as? FavouritesVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "WalletVC") as? WalletVC
            vc?.wallet_balance = self.userdetails.wallet_balance
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
            let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderListVC") as? OrderListVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 4:
            let vc = UIStoryboard.init(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromoCodeVC") as? PromoCodeVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 5:
            
            let vc = UIStoryboard.init(name: "Profile", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
            vc?.userID = self.userdetails.id
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
