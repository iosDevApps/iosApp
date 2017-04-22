//
//  Day.swift
//  ConferenceApp
//
//  Created by luka on 13/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

public final class Day: ManagedObject {
    @NSManaged public private(set) var date: Date
    @NSManaged public private(set) var lectures: Set<Lecture>
    @NSManaged public private(set) var event: Event
    
    fileprivate var mutableLectures: NSMutableSet {
        return mutableSetValue(forKey: #keyPath(lectures))
    }
    
    static func insert(into context: NSManagedObjectContext,
                       date: Date) {
        
        context.perform {
            let day: Day = context.insertObject()
            day.date = date
            _ = context.saveOrRollback()
            
        }
    }
    static private func createDateFromString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy" //Your date format
        let date = dateFormatter.date(from: dateString)!
        return date
    }

    static func findOrCreateDay(for lecturesDateString: String, lecturesJson: [LectureJson], into context: NSManagedObjectContext) -> Day {
        let lecturesDate = Day.createDateFromString(dateString: lecturesDateString)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(date), lecturesDate as CVarArg)
        let day = findOrCreate(in: context, matching: predicate) {
            $0.date = lecturesDate
            var lectures = [Lecture]()
            for lectureJson in lecturesJson {
                let lecture = Lecture.findOrCreateLecture(
                    lectureTitle: lectureJson.title,
                    lectureScheduledTime: lectureJson.scheduledTime,
                    lectureLocation: lectureJson.location,
                    lectureShortDescription: lectureJson.shortDescription,
                    with: lectureJson.lecturer,
                    into: context)
                lectures.append(lecture)
            }
            $0.mutableLectures.addObjects(from: lectures)
        }
        return day
    }

}

extension Day: Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}
