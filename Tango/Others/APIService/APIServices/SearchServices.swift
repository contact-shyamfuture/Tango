//
//  SearchServices.swift
//  Tango
//
//  Created by Samir Samanta on 08/09/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol SearchServicesProtocol {
    func getSearchresultDetails(searchValue : String , userID : String, completion: RequestCompletionHandler?)
    func getSearchresultNearByMeDetails(searchValue : String , userID : String, completion: RequestCompletionHandler?)
}
class SearchServices: SearchServicesProtocol {
    
    func getSearchresultDetails(searchValue : String ,userID : String, completion: RequestCompletionHandler?) {
        let Api = APIConstants.searchApi() + "\(userID)&name=\(searchValue)&latitude=22.486785&nearBy=true&longitude=88.360054"
        var header : [String: Any]
        if UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken) != nil {
            header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        }else{
            header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded"]
        }
        let urlString = Api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(urlString!, method: .get, parameters: nil, headers: (header as! HTTPHeaders)).responseObject {(response: DataResponse<SearchModel>) in
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
    
    func getSearchresultNearByMeDetails(searchValue : String ,userID : String, completion: RequestCompletionHandler?) {
        let Api = APIConstants.searchApi() + "\(userID)&name=\(searchValue)&latitude=22.486785&nearBy=false&longitude=88.360054"
        var header : [String: Any]
        if UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken) != nil {
            header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        }else{
            header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded"]
        }
        let urlString = Api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(urlString!, method: .get, parameters: nil, headers: (header as! HTTPHeaders)).responseObject {(response: DataResponse<SearchModel>) in
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
}
