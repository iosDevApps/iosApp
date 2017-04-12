//
//  EventJson.swift
//  ConferenceApp
//
//  Created by luka on 11/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class EventJson {
    let eventId: String
    let eventName: String
    let schedule: ScheduleJson
    let eventDuration: Int
    
    init?(json: [String: Any]) {
        guard
            let data = json["data"] as? [String: Any],
            let schedule = data["schedule"] as? [[String: Any]],
            let eventDuration = data["days"] as? Int,
            let eventId = data["event_id"] as? String,
            let eventName = data["eventName"] as? String
            
            else {
                return nil
        }
        self.eventDuration = eventDuration
        self.eventId = eventId
        self.eventName = eventName
        self.schedule = ScheduleJson(scheduleInfo: schedule)!
    }

}
