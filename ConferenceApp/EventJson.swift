//
//  EventJson.swift
//  ConferenceApp
//
//  Created by luka on 11/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class EventJson {
    
    let id: String
    let name: String
    let duration: Int
    
    init?(json: [String: Any]) {
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
}
