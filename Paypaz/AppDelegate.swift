//
//  AppDelegate.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Network
import IQKeyboardManagerSwift
import UserNotifications
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseMessaging 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    var isNetworkConnected : Bool?
    var notificationsFetched :(() -> ())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(path)
        let userID = UserDefaults.standard.getUserID()
        print("UserID is : ------- \(userID)")
        if #available(iOS 13.0, *) {
            window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        // Setting The google api key
        GMSPlacesClient.provideAPIKey("AIzaSyA5S2wr0I-x6Yp3HibMdjcAdIlZ9Gz0Cw0")
        GMSServices.provideAPIKey("AIzaSyD-X6F-HVtLHmYXeFNWz2z0Fi6ICqrW6_4")
        
        // ------->>IQKeyboard manager
        IQKeyboardManager.shared.enable            = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        FirebaseApp.configure()
        registerForPushNotifications(application: application)
        return true
    }
    
}
extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate{
    //MARK:- Notifications
    
    // When ever you receive any push notification this method will be called automatically
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("--------------------------------------------------------------------")
        print(userInfo)
        application.applicationIconBadgeNumber += 1
        completionHandler(.newData)
    }
    // When app is open then willPresent will call
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("----------UNUserNotificationCenter, willPresent notification--------------")
        notificationsFetched?()
        completionHandler([.alert, .sound, .badge])
    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("")
//    }
//    func applicationDidEnterForeground(_ application: UIApplication) {
//        if application.applicationIconBadgeNumber > 0{
//            UserDefaults.standard.setNotification_Dot(value: true)
//            application.applicationIconBadgeNumber = 0
//        }
//        else{
//            UserDefaults.standard.setNotification_Dot(value: false)
//        }
//    }
    
    private func registerForPushNotifications(application:UIApplication) {
        
        //application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[ .alert, .sound]){ (granted, error) in
            
            guard granted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("=================================")
        print("refreshed token is : \(String(describing: fcmToken))")
        UserDefaults.standard.setFireBaseToken(value: fcmToken ?? "")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("====fail to register notifications=====")
        print(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        /* if userInfo["gcm.notification.type"] as! String == "paynow"
         {
         let rootViewController = self.window!.rootViewController
         let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let walletVC = mainStoryboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
         rootViewController?.navigationController?.popToViewController(walletVC, animated: true)
         }*/
        completionHandler()
    }
    
}
/*extension AppDelegate : UNUserNotificationCenterDelegate{
 func registerForPushNotifications()
 {
 if #available(iOS 10.0, *)
 {
 
 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
 [weak self] (granted, error) in
 print("Permission granted: \(granted)")
 
 guard granted else {
 UserDefaults.standard.set("", forKey: "DeviceToken")
 return
 }
 
 self?.getNotificationSettings()
 }
 } else {
 let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
 UIApplication.shared.registerUserNotificationSettings(settings)
 UIApplication.shared.registerForRemoteNotifications()
 }
 }
 
 @available(iOS 10.0, *)
 func getNotificationSettings() {
 
 UNUserNotificationCenter.current().getNotificationSettings { (settings) in
 
 guard settings.authorizationStatus == .authorized else { return }
 DispatchQueue.main.async {
 UIApplication.shared.registerForRemoteNotifications()
 }
 }
 }
 
 // APNs device token
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
 // let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
 let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
 print("*****************")
 print("APNs device token: \(deviceTokenString.description)")
 UserDefaults.standard.set(deviceTokenString, forKey: "DeviceToken")
 }
 func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
 print("*****************")
 }
 
 
 
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
 print("*****************")
 print("Failed to register: \(error)")
 }
 
 func showPermissionAlert(){
 let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
 let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
 self?.gotoAppSettings()
 }
 let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
 alert.addAction(settingsAction)
 alert.addAction(cancelAction)
 DispatchQueue.main.async {
 self.window?.rootViewController?.present(alert, animated: true, completion: nil)
 }
 }
 
 private func gotoAppSettings() {
 guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else{
 return
 }
 if UIApplication.shared.canOpenURL(settingsUrl) {
 UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
 print("Settings opened: \(success)") // Prints true
 })
 }
 }
 
 }*/

