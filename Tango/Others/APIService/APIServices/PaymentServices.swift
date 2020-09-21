//
//  PaymentServices.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol PaymentServicesProtocol {
    func postOrderDetails(params: [String: Any] , completion: RequestCompletionHandler?)
}

class PaymentServices: PaymentServicesProtocol {
    
    func postOrderDetails(params : [String: Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.orderApi()
        //application/x-www-form-urlencoded  encoding: JSONEncoding.default,
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        
        Alamofire.request(loginApi, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseObject {(response: DataResponse<OrderDetailsModel>) in
            print("loginApi==>\(loginApi)")
            let loginApiResponse : Response!
            
            var responseStausCode: Int = 1
            var failureMessage: String = ""
            
            if let message = response.error?.localizedDescription {
                failureMessage = message
            }
            if let statusCode = response.response?.statusCode {
                responseStausCode = statusCode
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            switch(response.result) {
            case .success(let data):
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
