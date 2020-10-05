//
//  ThankYouVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 15/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ThankYouVC: BaseViewController {

    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderID: UILabel!
    var orderDetails = OrderDetailsModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        headerView.btnHeartOutlet.isHidden = true
        tabBarView.isHidden = true
        headerView.imgLogo.isHidden = false
        headerView.btnBackAction.isHidden = true
        lblOrderID.text = "\(orderDetails.invoiceDetails?.order_id ?? 0)"
        lblAmount.text = "\(orderDetails.invoiceDetails?.payable ?? 0)"
        //lblOrderName.text = "\(orderDetails.shopList?.name ?? "")"
        
        guard let items = orderDetails.userCart else {return}
        if items.count > 0{
            lblOrderName.text = "\(items[0].CartProduct?.name ?? "")(\(items[0].quantity ?? 0))"
        }
        
        lblPaymentMode.text = "\(orderDetails.invoiceDetails?.payment_mode ?? "")"
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
    }
    
    @IBAction func btnTrackOrderAction(_ sender: Any) {
        
    }
    
    @IBAction func btnDashboardAction(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
