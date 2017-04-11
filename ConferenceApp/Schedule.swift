//
//  Schedule.swift
//  ScheduleApp
//
//  Created by luka on 22/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class Schedule {
    
    var lecturesSchedule = [String: [Lecture]]()
    let scheduleDuration: Int
    let eventId: String
    let eventName: String
    
    init?(json: [String: Any]) {
        guard
            let data = json["data"] as? [String: Any],
            let scheduleInfo = data["schedule"] as? [[String: Any]],
            let scheduleDuration = data["days"] as? Int,
            let eventId = data["event_id"] as? String,
            let eventName = data["eventName"] as? String

            else {
                return nil
        }
        self.scheduleDuration = scheduleDuration
        self.eventId = eventId
        self.eventName = eventName
        lecturesInizialization(schedule: scheduleInfo)
    }
    
    func lecturesInizialization(schedule: [[String: Any]]) {
        var lectures = [Lecture]()
        for dailySchedule in schedule {
            guard
                let dailyScheduleDate = dailySchedule["day"] as? String,
                let dailyScheduleLectures = dailySchedule["lectures"] as? [[String: Any]]
            else {
                 return
            }
            
            lectures = dailyScheduleLectures.flatMap(Lecture.init)
            self.lecturesSchedule[dailyScheduleDate] = lectures
        }
    }
    
}
