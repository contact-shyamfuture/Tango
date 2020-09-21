//
//  ChatUsVC.swift
//  Tango
//
//  Created by Samir Samanta on 19/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import WebKit

class ChatUsVC: BaseViewController {
    @IBOutlet weak var chatUsWebview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.imgLogo.isHidden = true
        tabBarView.isHidden = true
        
        let request = URLRequest(url: URL(string: "https://console.dialogflow.com/api-client/demo/embedded/tango")!)

        chatUsWebview?.load(request)
    }
}
