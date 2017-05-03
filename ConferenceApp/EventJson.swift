//
//  EventJson.swift
//  ConferenceApp
//
//  Created by luka on 11/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class EventJson {
    
    var id: String = ""
    var name: String = ""
    var duration: Int = 0
    
    convenience init?(json: [String: Any]) {
        self.init()
        guard
            let eventDuration = json["days"] as? Int,
            let eventId = json["id"] as? String,
            let eventName = json["title"] as? String
            
            else {
                return nil
        }
        self.duration = eventDuration
        self.id = eventId
        self.name = eventName
    }
    
    convenience init(event: Event) {
        self.init()
        self.duration = Int(event.duration)
        self.id = event.id
        self.name = event.name
    }
}
