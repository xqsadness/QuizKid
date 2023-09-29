//
//  AppDelegate.swift
//  DefaultProject
//
//  Created by CycTrung on 04/06/2023.
//

import Foundation
import Firebase
import GoogleMobileAds
import AppTrackingTransparency
import CrowdinSDK
import Kingfisher

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setUpCrowdinSDK()
        
        //cache image
        let cache = ImageCache.default
            cache.diskStorage.config.sizeLimit = UInt(100 * 1024 * 1024) // Adjust the cache size as needed
            cache.memoryStorage.config.totalCostLimit = 30 * 1024 * 1024 // Adjust the memory cache size as needed
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .badge, .sound]) { (allowed, error) in
            if #available(iOS 14.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.appTracking()
                })
            }
        }
        return true
    }
    
    func setUpCrowdinSDK(){
        let providerConfig = CrowdinProviderConfig(hashString: "3cb996756cbbe1eed8c9779j50z", sourceLanguage: "en")
        let config = CrowdinSDKConfig.config().with(crowdinProviderConfig: providerConfig)
        
        CrowdinSDK.startWithConfig(config) {
            // added successfully
            print("added successfully")
        }
    }
    
    func appTracking(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
               
            }
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
//        if UserDefaults.standard.bool(forKey: "firstTerminate") == false && User.activeMore() && !User.shared.isPremium{
//            LocalNotification.shared.setLocalNotification(title: "Upgrade Premium Free Now!", subtitle: "Upgrade Premium without purchased", body: "Tap here to get free premium now!", when: 1, id: "cyc.moreapp")
//            UserDefaults.standard.setValue(true, forKey: "firstTerminate")
//       }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
