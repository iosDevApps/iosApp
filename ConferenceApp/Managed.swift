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
    static var entityName: String {
        print(entity().name!)
        return entity().name!
    }

    static var defaultSortDescriptor: [NSSortDescriptor] {
        return []
    }
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptor
        return request
    }
    
        static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }

    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)

        return try! context.fetch(request)
    }
    
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }
}



