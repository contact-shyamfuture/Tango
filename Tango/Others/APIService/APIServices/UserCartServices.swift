//
//  UserCartServices.swift
//  Tango
//
//  Created by Samir Samanta on 28/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol UserCartServicesProtocol {
    func postUserCart(params: [String: Any] , completion: RequestCompletionHandler?)
    func getUserCartDetails(completion: RequestCompletionHandler?)
}
class UserCartServices: UserCartServicesProtocol {
    
    func postUserCart(params : [String: Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.userCartApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        
        Alamofire.request(loginApi, method: .post, parameters: params, headers: header).responseObject {(response: DataResponse<UserCartModel>) in
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
    
    func getUserCartDetails(completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.userCartListApi() + "True"
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseObject {(response: DataResponse<UserCartModel>) in
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
