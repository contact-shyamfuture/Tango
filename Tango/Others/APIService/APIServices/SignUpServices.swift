//
//  SignUpServices.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol SignUpServicesProtocol {
    func sendLoginDetails(params: [String: Any], completion: RequestCompletionHandler?)
    func sendOTPDetails(params: [String: Any], completion: RequestCompletionHandler?)
    func sendOTPForForgotDetails(params: [String: Any], completion: RequestCompletionHandler?)
    func sendRegisterDetails(params: [String: Any], completion: RequestCompletionHandler?)
    
    func sendForgotChangePasswordDetails(params: [String: Any], completion: RequestCompletionHandler?)
}

class SignUpServices: SignUpServicesProtocol {
    
    func sendLoginDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.logInApi()
        print("params==>\(params)")
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<UserResponse>) in
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
    
    func sendOTPDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.otpApi()
        print("params==>\(params)")
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<UserOTPResponse>) in
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
    
    func sendRegisterDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.registerApi()
        print("params==>\(params)")
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: header).responseObject {(response: DataResponse<UserRegisterResponse>) in
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
    
    func sendOTPForForgotDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.forgotOtpApi()
        print("params==>\(params)")
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<UserOTPResponse>) in
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
    
    func sendForgotChangePasswordDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.forgotChangePasswordApi()
        print("params==>\(params)")
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<UserOTPResponse>) in
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
    
//    func sendForgotPasswordDetails(params: [String : Any], completion: RequestCompletionHandler?) {
//        let loginApi = APIConstants.logInApi()
//        print("params==>\(params)")
//        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<ForgotResponse>) in
//            print("loginApi==>\(loginApi)")
//            let loginApiResponse : Response!
//
//            var responseStausCode: Int = 1
//            var failureMessage: String = ""
//
//            if let message = response.error?.localizedDescription {
//                failureMessage = message
//            }
//            if let statusCode = response.response?.statusCode {
//                responseStausCode = statusCode
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//            switch(response.result) {
//            case .success(let data):
//                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
//            case .failure( _):
//                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
//            }
//            completion?(loginApiResponse)
//        }
//    }
//
//    func sendContactDetails(params: [String : Any], completion: RequestCompletionHandler?) {
//        let loginApi = APIConstants.logInApi()
//        print("params==>\(params)")
//        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<ForgotResponse>) in
//            print("loginApi==>\(loginApi)")
//            let loginApiResponse : Response!
//
//            var responseStausCode: Int = 1
//            var failureMessage: String = ""
//
//            if let message = response.error?.localizedDescription {
//                failureMessage = message
//            }
//            if let statusCode = response.response?.statusCode {
//                responseStausCode = statusCode
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//            switch(response.result) {
//            case .success(let data):
//                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
//            case .failure( _):
//                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
//            }
//            completion?(loginApiResponse)
//        }
//    }
}
