//
//  AppDelegate.swift
//  Tango
//
//  Created by Samir Samanta on 23/07/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AVFoundation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().barTintColor = Constants.App.navigationBarColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            self.openHomeViewController()
        } else {
            self.openSignInViewController()
        }
        return true
    }
    
    public func openSignInViewController(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        //UIApplication.shared.statusBarView?.backgroundColor =  UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
    }
    
    public func openHomeViewController(){
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        //UIApplication.shared.statusBarView?.backgroundColor =  UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
    }
    
    public static func appDelagate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func isReachable() -> Bool{
        if let isReachable = reachabilityManager?.isReachable {
            return isReachable
        }
        return false
    }
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        reachabilityManager?.startListening()
    }
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Tango")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

