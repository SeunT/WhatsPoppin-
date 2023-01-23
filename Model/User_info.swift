//
//  User_info.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/23/21.
//

import Foundation
import Firebase
import Foundation
import GeoFire
import CoreData
import FirebaseAuth
//import CoreLocation
enum DataErrors: Error {
    case empty
   
}
class User_info
{
    
    let userDefault = UserDefaults.standard
    var eventRef: DocumentReference!
    let db = Firestore.firestore()
    var user_info:info!
    var da:Data!
    
    init()
    {}
    
    
    func addUser(nm:String, pass:String, email:String,uid: String)
    {
        

        db.collection("users").document(uid).setData(["username":nm, "password":pass, "email":email])
        
        let f = info(fn: nm, fd: pass, fin: email)
        user_info = f
        
    }
    
    func deleteUser()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
        
            let userRef = db.collection("users").document((users.first?.uuid!)!)
            userRef.delete()
        }
        catch
        {
            print("Error deleting from firebase \(error)")
            
            }
        
        // Delete all data from Core_events entity
        let deleteEvents = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events"))
        do {
            try context.execute(deleteEvents)
        } catch {
            print("Error deleting objects from Core_events: \(error)")
        }
        // Delete all data from Core_user entity
        let deleteUser = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user"))
        do {
            try context.execute(deleteUser)
        } catch {
            print("Error deleting objects from Core_events: \(error)")
        }
        // Save the changes

        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
        
        
        
    }
    
    func logoutUser(completion: (Bool) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Delete all data from Core_events entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events")
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                let deleteEvents = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteEvents)
            }
        } catch {
            print("Error deleting objects from Core_events: \(error)")
        }
        // Delete all data from Core_user entity
        let deleteUser = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user"))
        do {
            try context.execute(deleteUser)
        } catch {
            print("Error deleting objects from Core_events: \(error)")
        }
        // Save the changes

        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
      //attempt to log out
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            print(error)
            completion(false)
            return
            
        }
    }
    
    func getUserEventData() -> [Core_events]
    {
        return UserCache.shared.getEvents()
    }
    func getUserData() -> Core_user?
    {
        return UserCache.shared.getUser()
    }
    
    func setup(user:String, image:String, nm:String, pfp:Data)
    {
      
        db.collection("users").document(user).setData(["image":image, "name":nm])

        //need to grab existing user 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            users.first!.setValue(user, forKey: "uuid")
            users.first!.setValue(nm, forKey: "name")
            users.first!.setValue(pfp, forKey: "pfp")
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    func addPP(user:String, image:String, nm:String)
    {
      
        db.collection("users").document(user).setData(["image":image, "name":nm])
        
    }
    func getOrCreateUser(cred:AuthCredential, completion:@escaping(Int) -> ())
    {
        var return_num = 0
        Auth.auth().signIn(with: cred)
        { (results, error) in
              if  error == nil
                {
                    
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let context = appDelegate.persistentContainer.viewContext
                  let newUser = NSEntityDescription.insertNewObject(forEntityName: "Core_user", into: context)
                  
                    self.db.collection("users").document(results!.user.uid).getDocument { (doc, erro) in
                        if erro == nil
                            {
                          
                            
                                if !(doc!.exists)
                                    { //account not created yet
                                            // go to nav1
                                    self.userDefault.setValue(results!.user.uid, forKey: "uuid")
                                    self.userDefault.synchronize()
                                
                                    return_num = 1
                                    completion(return_num)
                                    }
                                else if (doc!.exists)
                                    { //account is already created
                                    let storageRef = Storage.storage().reference(forURL: doc?.get("image") as! String)
                                    storageRef.downloadURL(completion: { (url, error) in
                                      
                                        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                                            guard let data = data, error == nil else {
                                                // handle the error here
                                                return
                                            }
                                            
                                            // Save the data to Core Data
                                            DispatchQueue.main.async {
                                              
                                                newUser.setValue(doc?.get("name") as? String, forKey: "name")
                                                newUser.setValue(data, forKey: "pfp")
                                                newUser.setValue(results!.user.uid, forKey: "uuid")
                                                do {
                                                    try context.save()
                                                    return_num = 2
                                                    completion(return_num)
                                                } catch {
                                                    print("Failed saving")
                                                }
                                            }
                                        }
                                        task.resume()
                                                
                                     
                                    })
                                  
                                  // go to nav 3
                                }
                                
                            }
                        self.db.collection("users").document(results!.user.uid).collection("events").getDocuments { doc, err in
                            if err == nil
                            {
                                
                            }
                        }
                       
                    }
                }
            else
              {
                
               //produce error message
                return_num = 3
               completion(return_num)
                //error verifying phone number
              }
            
        }
        
    }
    

    
}
class info
{
    var username:String?
    var password:String?
    var email:String?
   
    
    init(fn:String, fd:String, fin:String)
    {
        username = fn
        password = fd
        email = fin
        
    }
    
   
  
    
    
}

class User_Event
{
    var eventdis:String?
    var eventime:String?
    var eventimage:String?
    
    init(en:String, ed:String, ein:String)
    {
        eventdis = en
        eventime = ed
        eventimage = ein
        
    }
    
    
}

