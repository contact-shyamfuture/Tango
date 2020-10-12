//
//  SafetyMesureVC.swift
//  Tango
//
//  Created by Samir Samanta on 30/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import WebKit
class SafetyMesureVC: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    var id : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.imgLogo.isHidden = true
        headerView.btnBackAction.isHidden = false
        headerView.imgBackLogo.isHidden = false
        tabBarView.isHidden = true
        let url = "http://tangoeateries.com/footer-banner-details/\(id)"
        let myURLString = url
        let url2 = URL(string: myURLString)
        let request = URLRequest(url: url2!)
        
        headerView.btnHeartOutlet.isHidden = true
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    @IBAction func btnOkayAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension SafetyMesureVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
