//
//  Managed.swift
//  ConferenceApp
//
//  Created by luka on 10/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import  CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptor: [NSSortDescriptor] {get}
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name!  }

    static var defaultSortDescriptor: [NSSortDescriptor] {
        return []
    }
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptor
        return request
    }
}

extension Event: Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(eventId), ascending: false)]
    }
}
