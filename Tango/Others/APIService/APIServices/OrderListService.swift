//
//  OrderListService.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol OrderListProtocol {
    func getOrderListDetails(params: [String: Any] , completion: RequestCompletionHandler?)
    func getCompletedOrderDetails(params: [String: Any] , completion: RequestCompletionHandler?)
}

class OrderListServices: OrderListProtocol {
    
    func getOrderListDetails(params : [String: Any], completion: RequestCompletionHandler?) {
        let Api = APIConstants.orderListApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .get, parameters: params, headers: header).responseArray {(response: DataResponse<[OrderListModel]>) in
            print("loginApi==>\(Api)")
            
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data as AnyObject)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    
    func getCompletedOrderDetails(params : [String: Any], completion: RequestCompletionHandler?) {
        let Api = APIConstants.orderCompletedListApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .get, parameters: params, headers: header).responseArray {(response: DataResponse<[OrderListModel]>) in
            print("loginApi==>\(Api)")
            
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data as AnyObject)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
