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

//import CoreLocation
enum DataErrors: Error {
    case empty
   
}
class User_info
{
    var eventRef: DocumentReference!
    let db = Firestore.firestore()
    var user_info:info!
    var User_Events:[User_Event] = []
    let userDefault = UserDefaults.standard
    var da:Data!
    
    init()
    {
//        let f1 = Event(fn: "4 Miles away", fd: "Start Time: 8PM", fin: "party1.jpg")
//        let f2 = Event(fn: "10 Miles away", fd: "Start Time: 10PM", fin: "party2.jpg")
//        let f3 = Event(fn: "3 Miles away", fd: "Start Time: 6PM", fin: "party3.jpg")
//        let f4 = Event(fn: "14 Miles away", fd: "Start Time: 11:30PM", fin: "party4.jpg")
//        let f5 = Event(fn: "8 Miles away", fd: "Start Time: 12AM", fin: "party5.jpg")
//
//        Events.append(f1)
//        Events.append(f2)
//        Events.append(f3)
//        Events.append(f4)
//        Events.append(f5)
//
    }
    
    
    func addUser(nm:String, pass:String, email:String,uid: String)
    {
        

        db.collection("Users").document(uid).setData(["username":nm, "password":pass, "email":email])
        
        let f = info(fn: nm, fd: pass, fin: email)
        user_info = f
        
    }
    
    func addEventObject(user:String, coord:GeoPoint, desc: String, image: String, time:Date, addy:String)
    {
        
        let event = NSUUID().uuidString
        let documentRef =  db.collection("Events").document(event)
        let latitude = coord.latitude
        let longitude = coord.longitude
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let hash = GFUtils.geoHash(forLocation: location)

        // Add the hash and the lat/lng to the document. We will use the hash
        // for queries and the lat/lng for distance comparisons.


        eventRef = db.document(documentRef.path)
        
        db.collection("Events").document(event).setData(["description":desc, "time": time, "image":image, "address": addy, "geohash":hash, "lat": latitude, "lng": longitude])
        
        db.collection("Users").document(user).collection("Events").document(event).setData(["ref":eventRef!])
        
       

    }
    func setup(user:String, image:String, nm:String)
    {
      
        db.collection("Users").document(user).setData(["profile image":image, "Name":nm])
        
    }
    func addPP(user:String, image:String)
    {
      
        db.collection("Users").document(user).setData(["profile image":image])
        
    }
    
    func getEventsNearBy(lat: Double, long: Double, distance: Double, completion:@escaping([QueryDocumentSnapshot]) -> ())  {
        let group = DispatchGroup()
    
        // [START fs_geo_query_hashes]
               // Find cities within 50km of London
               let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
               let radiusInM: Double = distance * 1000

               // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
               // a separate query for each pair. There can be up to 9 pairs of bounds
               // depending on overlap, but in most cases there are 4.
    
               let queryBounds = GFUtils.queryBounds(forLocation: center,
                                                     withRadius: radiusInM)
               let queries = queryBounds.map { bound -> Query in
                   return db.collection("Events")
                       .order(by: "geohash")
                       .start(at: [bound.startValue])
                       .end(at: [bound.endValue])
               }

               var matchingDocs = [QueryDocumentSnapshot]()
               // Collect all the query results together into a single list
        // Initialize the DispatchGroup
   
               
       
               
        // Enter the group outside of the getDocuments call
        
        group.enter()
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> (){
            
            guard let documents = snapshot?.documents else {
                       print("Unable to fetch snapshot data. \(String(describing: error))")
                       return
                   }

                   for document in documents {
                       let lat = document.data()["lat"] as? Double ?? 0
                       let lng = document.data()["lng"] as? Double ?? 0
                       let coordinates = CLLocation(latitude: lat, longitude: lng)
                       let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)

                       // We have to filter out a few false positives due to GeoHash accuracy, but
                       // most will match
                       let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                       if distance <= radiusInM {
                           matchingDocs.append(document)
                       }
                   }
            group.leave()
         
        
        }
            // leave the group when done
            

   
        
       
            
         
               // After all callbacks have executed, matchingDocs contains the result. Note that this
               // sample does not demonstrate how to wait on all callbacks to complete.
               
               // [END fs_geo_query_hashes]
        
      
       for query in queries
       {
        query.getDocuments(completion: getDocumentsCompletion)
       }
        
  
        
        group.notify(queue: .main)//DispatchQueue.global(qos: .background)
        {
            completion(matchingDocs)
            
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

