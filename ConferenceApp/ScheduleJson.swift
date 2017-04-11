//
//  Schedule.swift
//  ScheduleApp
//
//  Created by luka on 22/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class ScheduleJson {
    
    var lecturesSchedule = [String: [LectureJson]]()
    
    init?(scheduleInfo: [[String: Any]]) {
        lecturesInizialization(schedule: scheduleInfo)
    }
    
    func lecturesInizialization(schedule: [[String: Any]]) {
        var lectures = [LectureJson]()
        for dailySchedule in schedule {
            guard
                let dailyScheduleDate = dailySchedule["day"] as? String,
                let dailyScheduleLectures = dailySchedule["lectures"] as? [[String: Any]]
            else {
                 return
            }
            
            lectures = dailyScheduleLectures.flatMap(LectureJson.init)
            self.lecturesSchedule[dailyScheduleDate] = lectures
        }
    }
    
}
