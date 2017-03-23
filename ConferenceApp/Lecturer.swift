//
//  Lecturer.swift
//  ScheduleApp
//
//  Created by luka on 17/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import Foundation

class Lecturer {
    let lecturerName: String
    let lecturerShortBio: String
    
    init?(lecturerInfo: [String: String]) {
        
        guard let lecturerName = lecturerInfo["name"],
            let lecturerShortBio = lecturerInfo["biography"]
            else {
                return nil
        }
        
        self.lecturerName = lecturerName
        self.lecturerShortBio = lecturerShortBio
    }
}
