//
//  EventSchedule.swift
//  ConferenceApp
//
//  Created by luka on 06/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

public final class EventSchedule: ManagedObject {
    @NSManaged public private(set) var eventId: Int16
    @NSManaged public private(set) var days: Int16
    @NSManaged public private(set) var schedule: [Any]
    
    static func insert(into context: NSManagedObjectContext,
                       eventId: Int16,
                       days: Int16,
                       schedule: Schedule,
                       completion: @escaping (EventSchedule) -> ()) {
        
        context.perform {
            let event: EventSchedule = context.insertObject()
            event.eventId = eventId
            event.days = days
            event.schedule = ["schedule"]
            _ = context.saveOrRollback()

            completion(event)
        }
    }
}
