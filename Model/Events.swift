//
//  Events.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//
import Firebase
import Foundation
import GeoFire
import Foundation
import FirebaseFirestore
import CoreData
class Events
{
    var Events:[Event] = []
    var eventRef: DocumentReference!
    let db = Firestore.firestore()
   
    
    init()
    {
        
    }
    
    func addEventObject(user:String, coord:GeoPoint, desc: String, images: Array<UIImage>, time:Date, addy:String)
    {
        
        let event = NSUUID().uuidString
        let documentRef =  db.collection("events").document(event)
        let latitude = coord.latitude
        let longitude = coord.longitude
        var count = 1
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let hash = GFUtils.geoHash(forLocation: location)
        
        // Add the hash and the lat/lng to the document. We will use the hash
        // for queries and the lat/lng for distance comparisons.
        
        
        eventRef = db.document(documentRef.path)
        
        db.collection("events").document(event).setData(["description":desc, "time": time,"address": addy, "geohash":hash, "lat": latitude, "lng": longitude,"eventID":event])
        
        images.forEach { UIImage in
            
            addEventPictures(image: UIImage, events: event, count:count)
            count = count+1
            print(count)
        }
        
        db.collection("users").document(user).collection("events").document(event).setData(["ref":eventRef!])
        
        
        
    }
    
    func addEventPictures(image:UIImage, events:String,count:Int)
    {
        
        let storageRef = Storage.storage().reference().child("Events/\(events)/\(events)_\(count).png") //Load the Firebase storage
        let compressionQuality: CGFloat = 0.5
        if let uploadData =  image.jpegData(compressionQuality: compressionQuality)
        {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let error = err {
                    print(error)
                    return
                }
            })
        }
        
    }
    
    func loadUserEvents(completion:@escaping(Bool) -> ())
    {
        let group = DispatchGroup()
        var counter = 0
        // first part
      
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Core_user entity
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")

        // Execute the fetch request and get the results
        do {
            
            let users = try context.fetch(fetchRequest1) as! [Core_user]
            if let user = users.first {
                let uuid = user.uuid
    
                group.enter()
                db.collection("users").document(uuid!).collection("events").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print(error)
                        group.leave()
                    } else {
                        
                 
                        for document in querySnapshot!.documents {

                            let ref = document.data()["ref"] as! DocumentReference

                            ref.getDocument { (res, err) in
                                if let err = err {
                                    print(err)
                                } else {
                                    let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Core_events", into: context)
                                    let event_date = res!.data()?["time"] as! Timestamp

                                    // Set the attributes for the new event
                                    newEvent.setValue(res!.data()?["eventID"] as! String, forKey: "uuid")
                                    newEvent.setValue(res!.data()?["address"] as! String, forKey: "addy")
                                    newEvent.setValue(res!.data()?["description"] as! String, forKey: "desc")
                                    newEvent.setValue(event_date.dateValue(), forKey: "time")
                                    do {
                                        counter += 1
                                        try context.save()
                                        if counter == querySnapshot?.count
                                        {
                                            group.leave()
                                        }
                                   
                                        print("success")
                                    } catch {
                                        print("Error saving new event: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error fetching user: \(error)")
        }
      
       
       
        group.notify(queue: .main)
        {
            //second part
            //load images
    

            // Create a fetch request for the Core_events entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events")
            
            // Execute the fetch request and get the results
            do {
                let events = try context.fetch(fetchRequest) as! [Core_events]
                
                var event_count = 0
                   
                   // Iterate through the events
                   for event in events {
                       let eventID = event.uuid

                       let storage = Storage.storage().reference().child("Events/\(eventID!)/")
                       
                       var images: [Data] = []
                       
                       storage.listAll { result, error in
                 
                           if let error = error {
                               print("Error listing images: \(error)")
                               return
                           }
                           
                           guard let result = result else {
                               print("nothing here")
                               // The result is nil, handle the error
                               return
                           }
                           
                           var count = 0
//                           for item in result.items {
                               // Create a URLSession with a timeout interval
                    
                               DispatchQueue.concurrentPerform(iterations: result.items.count) { index in
                                   let item = result.items[index]
                               // Download the image data from the URL
                               item.downloadURL { url, error in
                                   if let error = error {
                                       print("Error getting download URL for image: \(error)")
                                       return
                                   }
                                   
                                   if let url = url {
                                       
                                       let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                           if let error = error {
                                               print("Error downloading image: \(error)")
                                               return
                                           }
                                           
                                           if let data = data {
                                               count += 1
                                               images.append(data)
                                              
                                           }
             
                                           if count == result.items.count
                                           {
                                               
                                               do {
                                                   print(images.count)
                                                   event.setValue(images, forKey: "images")
                                                   event_count += 1
                                                   print("added succesfully")
                                                   try context.save()
                                                   
                                                   if event_count == events.count
                                                   {
                                                       print("event_count is \(event_count) and events.count is \(events.count)")
                                                       completion(true)
                                                   }
                                               }
                                               catch{
                                                   print("error saving images to entity")
                                               }
                                           
                                           }
                                            
                                        
                                       }
                                       
                                       task.resume()
                                       
                                   }
                               }
                               
                           }
                          
                       }
                }

               
            } catch {
                print("Error iterating through events and updating image data: \(error)")
            }
           
          
        }
        

    }
    
    func getEventData(eventID: String, completion: @escaping (Event) -> ()) {
        db.collection("events").document(eventID).getDocument { doc, error in
            if let error = error {
                print("Error getting event data: \(error)")
                return
            }
            
            if let doc = doc {
                let des = doc.data()?["description"] as? String ?? ""
                let addy = doc.data()?["address"] as? String ?? ""
                let time = doc.data()!["time"] as! Timestamp
                let event = Event(des: des, time: time, ad: addy)
                completion(event)
            }
        }
    }
    
    func getEventImages(eventID: String, Evnt: Event, completion: @escaping (Event) -> ()) {
        let storage = Storage.storage().reference().child("Events/\(eventID)/")
        var images: [UIImage] = []
        
        storage.listAll { result, error in
            if let error = error {
                print("Error listing images: \(error)")
                return
            }
            
            guard let result = result else {
                // The result is nil, handle the error
                return
            }
            
            for item in result.items {
                item.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL for image: \(error)")
                        return
                    }
                    
                    if let url = url {
                        // Use the ImageCache singleton to get the image
                        ImageCache.shared.getImage(urlString: url.absoluteString, completion: { image in
                            images.append(image!)
                            if images.count == result.items.count {
                                Evnt.set_img(img: images)
                                completion(Evnt)
                            }
                            
                        })
                        
                        
                    }
                }
            }
        }
    }
    
    
    func getEventsNearBy(lat: Double, long: Double, distance: Double, completion:@escaping([QueryDocumentSnapshot]) -> ())  {
        let group = DispatchGroup()
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let radiusInM: Double = distance * 1000
        let queryBounds = GFUtils.queryBounds(forLocation: center, withRadius: radiusInM)
        var matchingDocs = [QueryDocumentSnapshot]()

        // Check if the events are already cached
        if let cachedEvents = EventCache.shared.getCachedEvents(lat: lat, long: long, distance: distance) {
            matchingDocs = cachedEvents
            completion(matchingDocs)
        } else {
            var lastDocument: DocumentSnapshot?
            let limit = 10
            repeat {
                group.enter() // enter the group before making the query
                var query = db.collection("events")
                    .order(by: "geohash")
                    .limit(to: limit)
                
                if let lastDocument = lastDocument {
                    query = query.start(afterDocument: lastDocument)
                }
                
                for bound in queryBounds {
                    query = query.start(at: [bound.startValue]).end(at: [bound.endValue])
                }
                
                query.getDocuments { (snapshot, error) in
                    guard let documents = snapshot?.documents else {
                        print("Unable to fetch snapshot data. \(String(describing: error))")
                        return
                    }
//                    query.addSnapshotListener { (snapshot, error) in
//                                   guard let documents = snapshot?.documents else {
//                                       print("Unable to fetch snapshot data. \(String(describing: error))")
//                                       return
//                                   }
                    for document in documents {
                        let lat = document.data()["lat"] as? Double ?? 0
                        let lng = document.data()["lng"] as? Double ?? 0
                        let coordinates = CLLocation(latitude: lat, longitude: lng)
                        let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                        let distance = GFUtils.distance(from: centerPoint, to: coordinates)
                        if distance <= radiusInM {
                            matchingDocs.append(document)
                        }
                    }
                    lastDocument = documents.last
                    group.leave() // leave the group after the query is done
                }
            } while lastDocument != nil
            group.notify(queue: .main) {
                // cache the events
                EventCache.shared.cacheEvents(lat: lat, long: long, distance: distance, events: matchingDocs)
                completion(matchingDocs)
            }
        }
    }
}


class Event
{
    var eventdis:String?
    var eventime:Timestamp?
    var eventimage: Array<UIImage>?
    var addy:String?
    
    init(des:String, time:Timestamp,ad:String)
    {
        eventdis = des
        eventime = time
        eventimage = nil
        addy = ad
        
    }
    
    func set_img(img:Array<UIImage>)
    {
        eventimage = img
    }
    
    
}
