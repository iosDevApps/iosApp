//
//  Event.swift
//  ConferenceApp
//
//  Created by luka on 06/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

public final class Event: ManagedObject {
    // rename
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var duration: Int16
    @NSManaged public private(set) var days: Set<Day>
    
    fileprivate var mutableDays: NSMutableSet {
        return mutableSetValue(forKey: #keyPath(days))
    }
    
    
    private static func getDatesFromSchedule(schedule: ScheduleJson) -> [String] {
        return Array(schedule.lecturesSchedule.keys).sorted(by: <)
    }
    
    static func insert(into context: NSManagedObjectContext,
                       eventId: String,
                       eventName: String,
                       eventDuration: Int16,
                       schedule: ScheduleJson,
                       completion: @escaping (Event) -> ()) {
        let scheduledDays = Event.getDatesFromSchedule(schedule: schedule)
        context.perform {
            let event: Event = context.insertObject()
            var days = [Day]()
            event.id = eventId
            event.duration = eventDuration
            event.name = eventName
            for scheduledDay in scheduledDays {
                let lectures = schedule.lecturesSchedule[scheduledDay]
                let day = Day.findOrCreateDay(for: scheduledDay, lecturesJson: lectures!, into: context)
                print(NSStringFromClass(type(of: day)))
                days.append(day)
            }
            event.mutableDays.addObjects(from: days)
            _ = context.saveOrRollback()
            completion(event)
        }
    }
}

extension Event: Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: false)]
    }
}
