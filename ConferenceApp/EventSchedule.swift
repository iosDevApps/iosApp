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
    @NSManaged public private(set) var eventId: NSInteger
    @NSManaged public private(set) var days: NSInteger
    @NSManaged public private(set) var schedule: [Any]
}
