//
//  AppDelegate.swift
//  be #focused
//
//  Created by Efe Helvaci on 17.01.2017.
//  Copyright © 2017 efehelvaci. All rights reserved.
//

import UIKit
import Firebase
import Async
import FTIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        { (_, observer, name, _, _) in
                                            UserDefaults.standard.set(true, forKey: "kDisplayStatusLocked")
                                            UserDefaults.standard.synchronize()
        
                                        },
                                        ("com.apple.springboard.lockcomplete") as CFString,
                                        nil,
                                        CFNotificationSuspensionBehavior.deliverImmediately)
        
        UserDefaults.standard.set(false, forKey: "onFocus")
        
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.gray
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name: "Hiragino Sans", size: 22)!]
        UINavigationBar.appearance().isTranslucent = false
        
        FIRApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1014468065824783~2364922359")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if UserDefaults.standard.bool(forKey: "onFocus") {
            let appState : UIApplicationState = UIApplication.shared.applicationState
            if (appState == UIApplicationState.inactive) {
                print("Sent to background by locking screen");
            } else if (appState == UIApplicationState.background) {
                
                if(!UserDefaults.standard.bool(forKey: "kDisplayStatusLocked")) {
                    print("Sent to background by home button/switching to other app")
                    
                    NotificationCenter.default.post(Notification(name: Notification.Name("StatusChanged")))
                } else {
                    print("Sent to background by locking screen")
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UserDefaults.standard.set(false, forKey: "kDisplayStatusLocked")
        UserDefaults.standard.synchronize()
        
        Async.main(after: 2, {
            FTIndicator.dismissNotification()
            FTIndicator.dismissProgress()
            FTIndicator.dismissToast()
        })
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

