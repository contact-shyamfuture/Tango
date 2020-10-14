//
//  AppConstants.swift
//  DealerApp
//
//  Created by Shyam Future Tech on 28/01/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHandler = () -> ()
typealias RequestCompletionHandler = (Response) -> ()
typealias NetworkObserverCompletionHandler = (Network.Status) -> ()

let hostNameForRechabilityCheck = "www.google.com"

//let token = AppPreferenceService.getString(PreferencesKeys.userToken)
//let HeaderDic = ["Authorization": "Token " + AppPreferenceService.getString(PreferencesKeys.userToken)!,"Content-Type": "application/x-www-form-urlencoded"]

let IS_LOGGED_IN: Int = 1
let IS_LOGGED_OUT: Int = 0

struct Constants {
    
     struct App {
        static let navigationBarColor: UIColor = UIColor(rgb: 0xFF008A)
        static let statusBarColor: UIColor = UIColor(rgb: 0xCE060E)
    }
}

public struct PreferencesKeys {
    static let loggedInStatus = "loggedInStatus"
    static let userName = "userName"
    static let ICNum = "ICNum"
    static let userEmail = "userEmail"
    static let userImage = "userImage"
    static let userAccessToken = "userAccessToken"
    static let userrefreshToken = "userrefreshToken"
    static let userTokentype = "userTokentype"
    static let userPassword = "userPassword"
    static let userNotificationCount = "userNotificationCount"
    static let userBloodGroup = "userBloodGroup"
    static let userID = "userID"
    static let rememberMe = "rememberMe"
    static let priceTag = "priceTag"
    static let priceIDs = "priceIDs"
    static let stateID = "stateID"
    static let FCMTokenDeviceID = "FCMTokenDeviceID"
    static let userphone = "userphone"
    static let userFullName = "userFullName"
    
    static let memoryCreationStatus = "memoryCreationStatus"
    static let memoryID = "memoryID"
    
    // Last created memory Details
    static let memoryTitle = "memoryTitle"
    static let memoryPrimaryEmail = "memoryPrimaryEmail"
    static let memorySecondaryEmail = "memorySecondaryEmail"
    static let memoryPrimaryMobile = "memoryPrimaryMobile"
    static let memorySecondaryMobile = "memorySecondaryMobile"
    static let currentLat = "currentLat"
    static let currentLong = "currentLong"
    static let cartCount = "cartCount"
    
    static let mapLat = "mapLat"
    static let mapLong = "mapLong"
    static let mapType = "mapType"
    static let mapAddress = "mapAddress"
    
}
