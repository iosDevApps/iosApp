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
    @NSManaged public private(set) var eventId: String
    @NSManaged public private(set) var eventName: String
    @NSManaged public private(set) var days: Int16
    
    static func insert(into context: NSManagedObjectContext,
                       eventId: String,
                       eventName: String,
                       days: Int16,
                       completion: @escaping (Event) -> ()) {
        
        context.perform {
            let event: Event = context.insertObject()
            event.eventId = eventId
            event.days = days
            event.eventName = eventName
            _ = context.saveOrRollback()

            completion(event)
        }
    }
}
