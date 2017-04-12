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
    @NSManaged public private(set) var eventId: String
    @NSManaged public private(set) var eventName: String
    @NSManaged public private(set) var eventDuration: Int16
    
    static func insert(into context: NSManagedObjectContext,
                       eventId: String,
                       eventName: String,
                       eventDuration: Int16,
                       completion: @escaping (Event) -> ()) {
        
        context.perform {
            let event: Event = context.insertObject()
            event.eventId = eventId
            event.eventDuration = eventDuration
            event.eventName = eventName
            _ = context.saveOrRollback()

            completion(event)
        }
    }
}
