//
//  Lecture.swift
//  ConferenceApp
//
//  Created by luka on 13/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

public final class Lecture: ManagedObject {
    
    @NSManaged public private(set) var title: String
    @NSManaged public private(set) var scheduledTime: String
    @NSManaged public private(set) var location: String
    @NSManaged public private(set) var shortDesc: String
    @NSManaged public private(set) var day: Day
    @NSManaged public private(set) var lecturer: Lecturer
    
    static func insert(into context: NSManagedObjectContext,
                       title: String,
                       location: String,
                       scheduledTime: String,
                       shortDescription: String) {
        
        context.perform {
            let lecture: Lecture = context.insertObject()
            lecture.location = location
            lecture.scheduledTime = scheduledTime
            lecture.shortDesc = shortDescription
            lecture.title = title
            _ = context.saveOrRollback()
            
        }
    }
    
    static func findOrCreateLecture (
        lectureTitle: String,
        lectureScheduledTime: String,
        lectureLocation: String,
        lectureShortDescription: String,
        with lecturer: LecturerJson,
        into context: NSManagedObjectContext) -> Lecture {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(title), lectureTitle)
        let lecture = findOrCreate(in: context, matching: predicate) {
            $0.title = lectureTitle
            $0.scheduledTime = lectureScheduledTime
            $0.location = lectureLocation
            print(lectureLocation)
            print(lectureShortDescription)

            $0.shortDesc = lectureShortDescription
            print(lectureShortDescription)
            $0.lecturer = Lecturer.findOrCreateLecturer(
                with: lecturer.name,
                lecturerBio: lecturer.shortBio,
                into: context)
    }
    return lecture
    }
}

extension Lecture: Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(title), ascending: false)]
    }
}
