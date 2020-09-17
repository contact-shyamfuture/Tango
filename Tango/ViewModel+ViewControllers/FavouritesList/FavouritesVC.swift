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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true

        self.favouritesTable.register(UINib(nibName: "FavouritesCell", bundle: Bundle.main), forCellReuseIdentifier: "FavouritesCell")
        
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
    }
}

extension FavouritesVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
