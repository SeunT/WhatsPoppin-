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
import SDWebImage
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
    func getOtherUser(uid:String, completion:@escaping (info)->())
    {
        self.db.collection("users").document(uid).getDocument { (doc, erro) in
            if erro == nil
            {
                
                if (doc!.exists)
                { //account exists
                    
                    // Save the data to Core Data
                    DispatchQueue.main.async {
                        print(doc?.get("image") as? String ?? "")
                        print(doc?.get("bio"))
                        
                        let Info = info(fn: doc?.get("name") as? String ?? "", fd: doc?.get("bio") as? String ?? "", fin: doc?.get("image") as? String ?? "")
                        completion(Info)
                        
                    }
                    
                }
                
                
            }
        }
    }
    func getOtherUserEvents(uid:String, completion:@escaping (info)->())
    {
        self.db.collection("users").document(uid).getDocument { (doc, erro) in
            if erro == nil
            {
                
                if (doc!.exists)
                { //account exists
                    
                    // Save the data to Core Data
                    DispatchQueue.main.async {
                        print(doc?.get("image") as? String ?? "")
                        print(doc?.get("bio"))
                        
                        let Info = info(fn: doc?.get("name") as? String ?? "", fd: doc?.get("bio") as? String ?? "", fin: doc?.get("image") as? String ?? "")
                        completion(Info)
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    func updateUser(uid:String, model:[EditProfileFormModel])
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        context.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
            do {
                //update core data, database and clear cache
                for items in model
                {
                    let users = try context.fetch(fetchRequest) as! [Core_user]
                    users.first?.setValue(items.value ?? "", forKey: items.label)
                    self.db.collection("users").document(uid).setData([items.label:items.value ?? ""], merge: true)
                    
                }
                UserCache.shared.clearUserCache()
                
            }
            catch
            {
                print("Error deleting from firebase \(error)")
                
            }
            
            // Save the changes
            
            do {
                try context.save()
                context.refreshAllObjects()
                print("success saving edits")
            } catch {
                print("Error saving \(error)")
            }
        }
        
        
        
    }
    
    func addUser(nm:String, pass:String, email:String,uid: String)
    {
        

        db.collection("users").document(uid).setData(["username":nm, "password":pass, "email":email])
        
        let f = info(fn: nm, fd: pass, fin: email)
        user_info = f
        
    }
    
    func deleteUser_E(completion: @escaping(Bool) -> Void)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var document_count = 0
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            let UserID = (users.first?.uuid!)!
            db.collection("users").document(UserID).collection("events").getDocuments
            { docu,err in
                if let err = err {
                    print("error deleting in deleteUser_E\(err)")
                    // handle the error
                } else {
                    if docu!.isEmpty {
                        print("No documents found go ahead with normal delete")
                        self.deleteUser(){
                            res in
                            completion(res)
                        }
                    } else {
                        
                        for doc in docu!.documents
                        {
                            let eventID = doc.get("eventID") as! String
                            let eventref = self.db.collection("events").document(eventID)
                            
                            let EventImageRef = Storage.storage().reference().child("/Events/\(eventID)/")
                            let profileImageRef = Storage.storage().reference().child("/profiles/\((users.first?.uuid!)!)/")
                            let context = appDelegate.persistentContainer.viewContext
                            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events")
                            var count = 0
                            let userEventRef =  self.db.collection("users").document(UserID).collection("events").document(eventID)
                            
                            EventImageRef.listAll { (result, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    
                                    for item in result!.items {
                                        item.delete { (error) in
                                            if let error = error {
                                                print(error)
                                            }
                                            
                                            count += 1
                                            if(count == result!.items.count)
                                            {
                                                print("images succesfully deleted")
                                                
                                                eventref.delete()
                                                userEventRef.delete()
                                                document_count += 1
                                                
                                                request.predicate = NSPredicate(format: "uuid == %@", eventID)
                                                
                                                context.perform {
                                                    do {
                                                        let result = try context.fetch(request)
                                                        for object in result {
                                                            context.delete(object as! NSManagedObject)
                                            
                                                        }
                                                        try context.save()
                                                        UserCache.shared.clearEventCache()
                                                        print("succesfully deleted")
                                                        //                                                completion()
                                                        
                                                    } catch let error as NSError {
                                                        print("Could not delete. \(error), \(error.userInfo)")
                                                    }
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                }
                            }
                          
                            
                            profileImageRef.listAll { (result, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    
                                    for item in result!.items {
                                        item.delete { (error) in
                                            if let error = error {
                                                print(error)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        self.deleteUser()
                        {
                            _ in
                            if(document_count == docu?.count)
                            {
                                completion(true)
                                print("Sucess deleting in deleteUserE")
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            print("Error getting UserID in deleteUser_E \(error)")
            
        }
        
        
    }
    func deleteUser(completion: @escaping(Bool) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        var UserID:String!
        context.perform {
            
            do {
                let users = try context.fetch(fetchRequest) as! [Core_user]
                
                UserID = (users.first?.uuid!)!
                let userRef = self.db.collection("users").document((users.first?.uuid!)!)
                userRef.delete()
                print("success deleting user in regular DeleteUser for firebase")
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
                UserCache.shared.clearEventCache()
                UserCache.shared.clearUserCache()
                try context.save()
                context.refreshAllObjects()
            } catch {
                print("Error saving \(error)")
            }
        }
        
        //attempt to Delete
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                // An error happened.
                print(error)
                completion(false)
                return
            } else {
                // Account deleted.
                //delete the user data from firestore and storage
                
                let profileImageRef = Storage.storage().reference().child("/profiles/\(UserID!)/")
                profileImageRef.listAll { (result, error) in
                    if let error = error {
                        print(error)
                    } else {
                        
                        for item in result!.items {
                            item.delete { (error) in
                                if let error = error {
                                    print(error)
                                }
                            }
                        }
                    }
                }
                print("success deleting user in regular DeleteUser")
                completion(true)
                return
            }
        }
    }
    
    
    func logoutUser(completion: (Bool) -> Void)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Delete all data from Core_events entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events")
        context.perform{
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
                UserCache.shared.clearEventCache()
                UserCache.shared.clearUserCache()
                try context.save()
                context.refreshAllObjects()
            } catch {
                print("Error saving \(error)")
            }
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
    func getOtherUserEventData(ID:String, completion:@escaping ([Event])->())
    {
    OtherUserCache.shared.getEvents(userID: ID)
        { evnt in
            
            completion(evnt)
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
    
    func setup(user:String, image:String, nm:String)
    {
      
        db.collection("users").document(user).setData(["image":image, "name":nm, "bio": " "])

        //need to grab existing user 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            users.first!.setValue(user, forKey: "uuid")
            users.first!.setValue(nm, forKey: "name")
            users.first!.setValue(image, forKey: "pfp")
            users.first!.setValue(" ", forKey: "bio")
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    func addPP(user:String, image:String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
      

        //add it to core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            users.first?.setValue(image, forKey: "pfp")
            db.collection("users").document(user).updateData(["image":image])
            
            let url = URL(string:image)
            let manager = SDWebImageManager.shared
            manager.loadImage(with: url, options: .highPriority, progress: nil) { _,_,_,_,_,_  in}
        }
        catch
        {
            print("Error deleting from firebase \(error)")
            
        }
        
        // Save the changes

        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
        
        
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
                                      
//                                        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//                                            guard let data = data, error == nil else {
//                                                // handle the error here
//                                                return
//                                            }
//
                                            // Save the data to Core Data
                                            DispatchQueue.main.async {
                                              
                                                newUser.setValue(doc?.get("name") as? String, forKey: "name")
                                                newUser.setValue(url?.absoluteString, forKey: "pfp")
                                                newUser.setValue(results!.user.uid, forKey: "uuid")
                                                newUser.setValue(doc?.get("bio") as? String, forKey: "bio")
                                                newUser.setValue(doc?.get("email") as? String, forKey: "email")
                                                newUser.setValue(doc?.get("gender") as? String, forKey: "gender")
                                                do {
                                                    try context.save()
                                                    return_num = 2
                                                    completion(return_num)
                                                } catch {
                                                    print("Failed saving")
                                                }
                                            }
//                                        }
//                                        task.resume()
                                                
                                     
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
    var bio:String?
    var pfp:String?
   
    
    init(fn:String, fd:String, fin:String)
    {
        username = fn
        bio = fd
        pfp = fin
        
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

