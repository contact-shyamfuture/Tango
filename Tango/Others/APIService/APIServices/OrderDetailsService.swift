//
//  OrderDetailsService.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol OrderDetailsProtocol {
    func getOrderDetailsDetails(OrderID : String,params: [String: Any] , completion: RequestCompletionHandler?)
    func getOrderDispute(params: [String: Any] , completion: RequestCompletionHandler?)
    func getOrderCancel(OrderID : String,reason : String,params: [String: Any] , completion: RequestCompletionHandler?)
}

class OrderDetailsServices: OrderDetailsProtocol {
    
    func getOrderDetailsDetails(OrderID : String,params : [String: Any], completion: RequestCompletionHandler?) {
        let Api = APIConstants.orderDetailsApi() + "\(OrderID)"
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .get, parameters: params, headers: header).responseObject {(response: DataResponse<OrderSummeryModel>) in
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    func getOrderDispute(params: [String: Any] , completion: RequestCompletionHandler?){
        let Api = APIConstants.orderDisputeApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .post, parameters: params, headers: header).responseObject {(response: DataResponse<OrderDisputeModel>) in
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    func getOrderCancel(OrderID : String,reason : String,params: [String: Any] , completion: RequestCompletionHandler?){
        let Api = APIConstants.orderDetailsApi() + "\(OrderID)?reason=\(reason)"
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        let urlString = Api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(urlString!, method: .delete, parameters: params, headers: header).responseObject {(response: DataResponse<OrderCancelModel>) in
            print("loginApi==>\(urlString ?? "")")
            
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
