//
//  Lecture.swift
//  ScheduleApp
//
//  Created by luka on 17/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class Lecture {
    
    let lectureTitle: String
    let lectureScheduledTime: String
    let lecturerName: String
    let lectureLocation: String
    let lectureShortDescription: String
    let lecturer: Lecturer

    init?(lecturesInfo: [String: Any]) {
        
        guard
            let lectureScheduledTime = lecturesInfo["time"] as? String,
            let lectureTitle = lecturesInfo["title"] as? String,
            let lecturerInfo = lecturesInfo["lecturer"] as? [String: String],
            let lectureLocation = lecturesInfo["location"] as? String,
            let lectureShortDescription = lecturesInfo["short_descripton"] as? String
            
            else {
                return nil
            }
        
        let lecturer = Lecturer(lecturerInfo: lecturerInfo)
        
        self.lecturer = lecturer!
        
        self.lecturerName = (lecturer?.lecturerName)!
        
        self.lectureShortDescription = lectureShortDescription
        self.lectureLocation = lectureLocation

        self.lectureTitle = lectureTitle
        self.lectureScheduledTime = lectureScheduledTime
        
    }
        
}
