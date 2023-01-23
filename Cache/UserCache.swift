//
//  UserCache.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/19/23.
//

import Foundation
import CoreData
class UserCache {
    static let shared = UserCache()
    private var events: [String: Core_events] = [:]
    private let context = AppDelegate().persistentContainer.viewContext
    private var user: Core_user?
    private init() {}
    
    
    func getEvents() -> [Core_events] {
        if events.isEmpty {
            loadEvents()
        }
        return Array(events.values)
    }
    
    
    private func loadEvents() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_events")
        do {
            let eventsFromCoreData = try context.fetch(fetchRequest) as! [Core_events]
            eventsFromCoreData.forEach { event in
                events[event.uuid!] = event
            }
        } catch {
            print("Error loading events from Core Data: \(error)")
        }
    }
     
    
    func getUser() -> Core_user? {
        
        if let cachedUser = user {
            return cachedUser
        } else {
           
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
            do {
                let users = try context.fetch(fetchRequest) as! [Core_user]
                if let foundUser = users.first {
                    user = foundUser
                    return user
                }
            } catch {
                print("Error fetching user from Core Data: \(error)")
            }
            return nil
        }
    }
    
}
