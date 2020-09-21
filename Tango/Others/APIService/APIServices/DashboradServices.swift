//
//  DashboradServices.swift
//  Tango
//
//  Created by Samir Samanta on 25/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
protocol DashboradServicesProtocol {
    func getRestaurantListDetails(lat : String, long : String, id : String , completion: RequestCompletionHandler?)
    
    func getProfileDetails(device_type : String, device_token : String, device_id : String , completion: RequestCompletionHandler?)
    func getTopBanner(completion: RequestCompletionHandler?)
    func getSafetyBanner(completion: RequestCompletionHandler?)
    func getWalletsDetails(completion: RequestCompletionHandler?)
    
}

class DashboradServices: DashboradServicesProtocol {
    
    func getRestaurantListDetails(lat : String, long : String, id : String, completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.baseURL + "api/user/shops?latitude=22.4705668&nearBy=true&longitude=88.3524203&user_id=57&data_for=app"
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded"]
        //, "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseObject {(response: DataResponse<RestaurantModel>) in
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
    
    
    func getProfileDetails(device_type : String, device_token : String, device_id : String, completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.baseURL + "api/user/profile?device_type=\(device_type)&device_token=\(device_token)&device_id=\(device_id)"
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        //, "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseObject {(response: DataResponse<ProfiledetailsModel>) in
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
    
    func getTopBanner(completion: RequestCompletionHandler?) {
       
        let loginApi = APIConstants.bannerApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        //, "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseArray {(response: DataResponse<[TopBannerModel]>) in
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data as AnyObject)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    
    func getSafetyBanner(completion: RequestCompletionHandler?) {
       
        let loginApi = APIConstants.safetyBannerApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        //, "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseArray {(response: DataResponse<[SafetyModel]>) in
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data as AnyObject)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
    
    func getWalletsDetails(completion: RequestCompletionHandler?) {
       
        let loginApi = APIConstants.walletsApi()
        
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: header).responseArray {(response: DataResponse<[WalletsModel]>) in
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
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data as AnyObject)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
