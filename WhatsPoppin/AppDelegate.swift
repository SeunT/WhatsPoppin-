//
//  AppDelegate.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/19/21.
//

import UIKit
import Firebase
import CoreData
import FirebaseAppCheck
import UserNotifications
import FirebaseMessaging
import FirebaseDynamicLinks
import FirebaseCore

class YourAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, NSUserActivityDelegate, MessagingDelegate {

    var listenerAdded = false
    var listener: ListenerRegistration!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        IAPManager.shared.fetchProduct()
        // Register for remote notifications
           UNUserNotificationCenter.current().delegate = self
        
           let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            if granted {
                print("Notification authorization granted.")
            } else {
                print("Notification authorization denied.")
            }
               guard granted else { return }
               DispatchQueue.main.async {
                   application.registerForRemoteNotifications()
               }
           }

        let providerFactory = YourAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        FirebaseApp.configure()
        addSnapshot()
        print("removing map keys")
        UserDefaults.standard.removeObject(forKey: "map_latitude")
        UserDefaults.standard.removeObject(forKey: "map_longitude")
        UserDefaults.standard.removeObject(forKey: "map_latitude_delta")
        UserDefaults.standard.removeObject(forKey: "map_longitude_delta")
        UserDefaults.standard.set(true, forKey: "updateMap")
        UserDefaults.standard.synchronize()
        print("Done removing map keys")
        
        Messaging.messaging().delegate = self
        // Override point for customization after application launch.
        return true
    }

    
    func addSnapshot() {
        let db = Firestore.firestore()
            if !listenerAdded {
                listener = db.collection("events").addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        print("Error adding snapshot listener: \(error)")
                    } else {
                        // Clear cached events and get a new batch here
                        if let snapshot = snapshot {
                            
                            if !snapshot.documentChanges.isEmpty {
                                // Clear cached events and get a new batch here
                                NotificationCenter.default.post(name: NSNotification.Name("RefreshViewController"), object: nil)
                                EventCache.shared.clearCache()
                            }
                        }
                    }
                }
                listenerAdded = true
            }
        }

        func applicationWillTerminate(_ application: UIApplication) {
         
            if listenerAdded {
                print("listener is removed")
                listener.remove()
                EventCache.shared.clearCache()
                listenerAdded = false
            }
  
        }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "coreModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token{
            token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
        //maybe put theupdate fcmtoken in here
    }
    
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Save the device token in your backend system
        Messaging.messaging().apnsToken = deviceToken
        let fcmToken = Messaging.messaging().fcmToken ?? ""
     //check if doc is not empty instead
        Auth.auth().currentUser?.reload{
            done in
            if let user = Auth.auth().currentUser {
                let docRef = Firestore.firestore().collection("users").document(user.uid)
                docRef.setData(["fcmToken": fcmToken], merge: true) { error in
                    if let error = error {
                        print("Error saving FCM token: \(error.localizedDescription)")
                    } else {
                        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
                        UserDefaults.standard.synchronize()
                        print("FCM token saved successfully")
                    }
                }
            }
            //else save it in user defaults when the user creats an account if there is no current user
            else
            {
                UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
                UserDefaults.standard.synchronize()
            }
        }
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the silent notification here
        if let contentAvailable = userInfo["content-available"] as? Int, contentAvailable == 1 {
          // Handle the silent push notification here.
        }
        print("Received silent push notification: \(userInfo)")
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

//    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink)
//    {
//        guard let url = dynamicLink.url else {
//            print("No url present in dynamic Link")
//            return
//        }
//        print("incoming dynamic link is \(url.absoluteString)")
//    }
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//
//        if let incomingURL = userActivity.webpageURL {
//            print("incoming URL is \(incomingURL)")
//            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){
//                (dynamicLink,error) in
//                guard error == nil else {
//                    print("Found an error! \(error!.localizedDescription)")
//                    return
//                }
//                if let dynamicLink = dynamicLink {
//                    self.handleIncomingDynamicLink(dynamicLink)
//                }
//            }
//            if linkHandled {
//                return true
//            }
//            else {
//                //maybe do other things with the incoming url
//                return false
//            }
//        }
//        return false
//    }

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//      let handled = DynamicLinks.dynamicLinks()
//        .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
//          // ...
//        }
//
//      return handled
//    }
    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
//      return application(app, open: url,
//                         sourceApplication: options[UIApplication.OpenURLOptionsKey
//                           .sourceApplication] as? String,
//                         annotation: "")
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
//                     annotation: Any) -> Bool {
//      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//        // Handle the deep link. For example, show the deep-linked content or
//        // apply a promotional offer to the user's account.
//        // ...
//        return true
//      }
//      return false
//    }
}

