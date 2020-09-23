//
//  AddressServices.swift
//  Tango
//
//  Created by Shyam Future Tech on 02/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol AddressServicesProtocol {
    func getAddressDetails(params: [String: Any] , completion: RequestCompletionHandler?)
    func getAddressSaveDetails(params: [String: Any] , completion: RequestCompletionHandler?)
    func deleteAddressDetails(addressID : String , completion: RequestCompletionHandler?)
}

class AddressServices: AddressServicesProtocol {
    
    func getAddressDetails(params : [String: Any], completion: RequestCompletionHandler?) {
        let Api = APIConstants.addressApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .get, parameters: params, headers: header).responseArray {(response: DataResponse<[AddressListModel]>) in
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
    func getAddressSaveDetails(params : [String: Any], completion: RequestCompletionHandler?) {
        let Api = APIConstants.addressApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        print("parameter==> ",params)
        
        Alamofire.request(Api, method: .post, parameters: params, headers: header).responseObject {(response: DataResponse<AddressSaveModel>) in
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
    
    func deleteAddressDetails(addressID : String , completion: RequestCompletionHandler?) {
        let Api = APIConstants.deleteAddressApi() + addressID
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        print("Header: ",header)
        
        
        Alamofire.request(Api, method: .delete, parameters: nil, headers: header).responseObject {(response: DataResponse<AddressSaveModel>) in
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
