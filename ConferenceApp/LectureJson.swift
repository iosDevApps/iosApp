//
//  Lecture.swift
//  ScheduleApp
//
//  Created by luka on 17/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class LectureJson {
    
    let title: String
    let scheduledTime: String
    let location: String
    let shortDescription: String
    let lecturer: LecturerJson

    init?(lecturesInfo: [String: Any]) {
        guard
            let lectureScheduledTime = lecturesInfo["time"] as? String,
            let lectureTitle = lecturesInfo["title"] as? String,
            let lecturerInfo = lecturesInfo["lecturer"] as? [String: String],
            let lectureLocation = lecturesInfo["location"] as? String,
            let lectureShortDescription = lecturesInfo["short_description"] as? String
            
            else {
                return nil
            }
        
        let lecturer = LecturerJson(lecturerInfo: lecturerInfo)
        
        self.lecturer = lecturer!
        
        self.shortDescription = lectureShortDescription
        self.location = lectureLocation

        self.title = lectureTitle
        self.scheduledTime = lectureScheduledTime
        
    }
    
    init?(lecture: Lecture, lecturer: Lecturer) {
        self.title = lecture.title
        self.location = lecture.location
        self.scheduledTime = lecture.scheduledTime
        self.shortDescription = lecture.shortDesc
        self.lecturer = LecturerJson(lecturer: lecturer)!
    }
        
}
