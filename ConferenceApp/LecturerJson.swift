//
//  Lecturer.swift
//  ScheduleApp
//
//  Created by luka on 17/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class LecturerJson {
    let name: String
    let shortBio: String
    
    init?(lecturerInfo: [String: String]) {
        
        guard let lecturerName = lecturerInfo["name"],
            let lecturerShortBio = lecturerInfo["biography"]
            else {
                return nil
        }
        
        self.name = lecturerName
        self.shortBio = lecturerShortBio
    }
    init?(lecturer: Lecturer) {
        self.name = lecturer.name
        self.shortBio = lecturer.biography
    }
}
