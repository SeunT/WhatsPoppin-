//
//  SceneDelegate.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/19/21.
//

import UIKit
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
   

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Check if the app was launched from a Firebase Dynamic Link
        if let userActivity = connectionOptions.userActivities.first,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url){
                (dynamicLink,error) in
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }

                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink)
                }
            }
        } else if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            self.scene(scene, continue: userActivity)
        }
//
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    func handleDynamicLink(_ dynamicLink: DynamicLink)
    {
        // Check if there is a currently signed-in user
        if Auth.auth().currentUser != nil {
            // User is signed in
            // You can perform actions for a signed-in user here
        
           // Handle the dynamic link
           // For example, you might present a view controller that displays the content associated with the link
        guard let url = dynamicLink.url else {
            print("No url present in dynamic Link")
            return
        }
        print("incoming dynamic link is \(url.absoluteString)")

        guard (dynamicLink.matchType == .unique || dynamicLink.matchType == .default) else {
            // Not a strong enough match. lets just not do anything
            print("Not a strong enough match type to continue")
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {return}
        
//        for queryItem in queryItems {
//            print("parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
//        }
        
        if components.path == "/whatspoppin/events" {
            //we are loading up a specific event
            
            if let eventIDQueryItem = queryItems.first(where: {$0.name == "eventID"}) {
                guard let eventID = eventIDQueryItem.value else {return}
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               guard let eventVC = storyBoard.instantiateViewController(withIdentifier: "Event") as? EventViewController else { return }
                eventVC.eventID = eventID
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nav3 = storyboard.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = nav3
                nav3.pushViewController(eventVC, animated: true)
                
                
                
            }
        }
        if components.path == "/whatspoppin/profiles" {
            //we are loading up a specific event
            
            if let profileIDQueryItem = queryItems.first(where: {$0.name == "profileID"}) {
                guard let profileID = profileIDQueryItem.value else {return}
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//               guard let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as? NewProfileViewController else { return }

                //need to check if current user or not most likely going to be not current user
                let currUserID = (UserCache.shared.getUser()?.uuid)!
                let otherUserID = profileID
                if(otherUserID == currUserID)
                {
                    let profileVC = NewProfileViewController(currentUser: true, currId: profileID)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nav3 = storyboard.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = nav3
                    nav3.pushViewController(profileVC, animated: true)
                }
                else
                {
                    
                    let profileVC = NewProfileViewController(currentUser: false, currId: profileID)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nav3 = storyboard.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = nav3
                    nav3.pushViewController(profileVC, animated: true)
                }
     
            }
        }

        } else {
            // No user is signed in
            // You can perform actions for a signed-out user here
            //tell them to log in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav2 = storyboard.instantiateViewController(withIdentifier: "Nav2") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = nav2
            let alert = UIAlertController(title: "Login", message: "You need to be logged in to use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil ))
            nav2.present(alert, animated: true)
        }
            
       }
       
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        print("[Scene] Application continue user activity...")
        if let incomingURL = userActivity.webpageURL {
            print("incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){
                (dynamicLink,error) in
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink)
                }
            }
            //            if linkHandled {
            //                return true
            //            }
            //            else {
            //                //maybe do other things with the incoming url
            //                return false
            //            }
            //        }
            //        return false
            //
        }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//      let handled = DynamicLinks.dynamicLinks()
//        .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
//          // ...
//        }
//
//      return handled
        if let incomingURL = userActivity.webpageURL {
            print("incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL){
                (dynamicLink,error) in
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink)
                }
            }
            if linkHandled {
                return true
            }
            else {
                //maybe do other things with the incoming url
                return false
            }
        }
        return false
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received a URl through a custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
        {
            self.handleDynamicLink(dynamicLink)
            return true
        } else {
            return false
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

