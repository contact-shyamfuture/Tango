//
//  FavouritesVC.swift
//  Tango
//
//  Created by Samir Samanta on 29/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class FavouritesVC: BaseViewController {
    @IBOutlet weak var favouritesTable: UITableView!
    lazy var viewModel: UserCratVM = {
           return UserCratVM()
       }()
    var favoritesList : [FavoritesList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        self.favouritesTable.register(UINib(nibName: "FavouritesCell", bundle: Bundle.main), forCellReuseIdentifier: "FavouritesCell")
        headerView.btnHeartOutlet.isHidden = true
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
        initializeViewModel()
        getFavorites()
    }
    
    func getFavorites(){
        viewModel.getFavoritesListToAPIService()
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
        
        viewModel.refreshFavoritesListViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.favoritesDetails.favoritesList) != nil {
                    self!.favoritesList = self?.viewModel.favoritesDetails.favoritesList
                    self!.favouritesTable.reloadData()
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Faild", okButtonText: okText, completion: nil)
                }
            }
        }
    }
}

extension FavouritesVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesList != nil && favoritesList!.count > 0 {
            return favoritesList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: favouritesTable.layer.bounds.width, height: favouritesTable.layer.bounds.height))
        vw.backgroundColor = UIColor.init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        let titleLbl = UILabel(frame: CGRect(x: 20, y: 3, width: favouritesTable.layer.bounds.width - 10, height: 50))
        titleLbl.text = "AVIALABLE"
        titleLbl.font = UIFont.init(name: "Roboto-Regular", size: 20)
        vw.addSubview(titleLbl)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell") as! FavouritesCell
        Cell.initializeCellDetails(cellDic: favoritesList![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
