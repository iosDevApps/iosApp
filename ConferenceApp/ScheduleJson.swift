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
    
    init?(for event: Event) {
        self.lecturesSchedule = createScheduleJsonFor(event: event)
    }
    
    func getDates() -> [String] {
        return Array(lecturesSchedule.keys).sorted(by: <)
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
    
    func createScheduleJsonFor(event: Event) -> [String: [LectureJson]] {
        var schedule = [String: [LectureJson]]()
        let days = event.days
        for day in days {
            let dateString = day.createStringFrom(date: day.date)
            var lectures = [LectureJson]()
            for lecture in day.lectures {
                print(lecture.lecturer.name)
                let lectureJson = LectureJson(lecture: lecture, lecturer: lecture.lecturer)
                lectures.append(lectureJson!)
            }
            schedule[dateString] = lectures
        }
        return schedule
    }
}
