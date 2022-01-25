//
//  Events.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//

import Foundation
class Events
{
    var Events:[Event] = []
    
    init()
    {
        let f1 = Event(fn: "Kickback", fd: "8PM", fin: "party1.jpg", ad:"813 N College Ave, Tempe, AZ 85281")
        let f2 = Event(fn: "Birthday party", fd: "10PM", fin: "party2.jpg", ad:"15 Harvey St. Anaheim, CA 92801")
        let f3 = Event(fn: "video game tournament", fd: "6PM", fin: "party3.jpg", ad:"2107 Travis Heights Blvd Austin, TX  78704")
        let f4 = Event(fn: "just lounging around", fd: "11:30PM", fin: "party4.jpg",ad:"913 20th St Union City, NJ  07087")
        let f5 = Event(fn: "charity for feed the starving children", fd: "12AM", fin: "party5.jpg",ad:"2335 Yale Ave E Seattle, WA  98102")
        
        Events.append(f1)
        Events.append(f2)
        Events.append(f3)
        Events.append(f4)
        Events.append(f5)
        
    }
    
    func getCount() -> Int
    {
        return Events.count
    }
    
    func getEventObject(item:Int) -> Event{
        
        return Events[item]
    }
    
    func removeEventObject(item:Int) {
        
         Events.remove(at: item)
    }
    
    func addEventObject(name:String, desc: String, image: String, ady:String) -> Event{
        let f = Event(fn: name, fd: desc, fin: image, ad: ady)
        Events.append(f)
        return f
    }
    
}
class Event
{
    var eventdis:String?
    var eventime:String?
    var eventimage:String?
    var addy:String?
    
    init(fn:String, fd:String, fin:String,ad:String)
    {
        eventdis = fn
        eventime = fd
        eventimage = fin
        addy = ad
        
    }
    
    
}
