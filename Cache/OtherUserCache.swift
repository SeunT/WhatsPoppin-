//
//  OtherUserCache.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/28/23.
//

import Foundation
import Firebase
class OtherUserCache {
    static let shared = OtherUserCache()
    private var events: [String: [Event]] = [:]
    var Eventt:Events = Events()
    let db = Firestore.firestore()
    private init() {}
    
    func getEvents(userID: String, completion: @escaping ([Event]) -> ()) {
        if events[userID] == nil {
            loadEvents(userId: userID) { events in
                completion(events)
            }
        } else {
            completion(events[userID] ?? [])
        }
    }
    
    private func loadEvents(userId: String, completion: @escaping ([Event]) -> ()) {
        events[userId] = []
        //grab all eventIDs
        db.collection("users").document(userId).collection("events").getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            } else if querySnapshot!.isEmpty {
                return
            }
            else {
                for document in querySnapshot!.documents
                {
                    let eventId = document.data()["eventID"] as! String

                    self.Eventt.getEventData(eventID: eventId)
                    {
                        Evnt in
                        self.Eventt.getEventImages(eventID: eventId, Evnt: Evnt) {
                            final_evnt in
                            self.events[userId]?.append(final_evnt)
                            if document == querySnapshot!.documents.last {
                                completion(self.events[userId] ?? [])
                            }
                        }
                    }
                }

            }
        }
    }
}
