//
//  EventCache.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/15/23.
//

import Foundation
import FirebaseFirestore
class EventCache {
    static let shared = EventCache()
    private var cache = [String: [QueryDocumentSnapshot]]()
    
    private init() {}
    
    func cacheEvents(lat: Double, long: Double, distance: Double, events: [QueryDocumentSnapshot]) {
        let key = "\(lat)-\(long)-\(distance)"
        cache[key] = events
    }
    
    func getCachedEvents(lat: Double, long: Double, distance: Double) -> [QueryDocumentSnapshot]? {
        let key = "\(lat)-\(long)-\(distance)"
        return cache[key]
    }
}
