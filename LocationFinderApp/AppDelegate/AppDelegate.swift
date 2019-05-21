//
//  AppDelegate.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare on 5/20/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import Loki
import IQKeyboardManagerSwift
let googleApiKey = "AIzaSyDf8Fz5E2q0zvacW9_D-C-Uja7QrEKuatQ"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleApiKey)
        LKManager.add(LKLanguage.init(name: "English", code: "en", title: "English"))
        LKManager.add(LKLanguage.init(name: "Spanish", code: "es", title: "Spanish"))
        IQKeyboardManager.shared.enable = true
        setupLanguage()
        return true
    }
    
    func setupLanguage() {
        if let value = UserDefaults.standard.value(forKey: KLanguagekey) as? String{
            if value == "en"{
                if let item = LKManager.sharedInstance().languages[0] as? LKLanguage {
                    LKManager.sharedInstance().currentLanguage = item
                }
            }else{
                if let item = LKManager.sharedInstance().languages[1] as? LKLanguage {
                    LKManager.sharedInstance().currentLanguage = item
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.sharedManager.saveContext()
    }

}

