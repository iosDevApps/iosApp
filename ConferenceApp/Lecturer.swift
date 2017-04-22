//
//  Lecturer.swift
//  ConferenceApp
//
//  Created by luka on 13/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

public final class Lecturer: ManagedObject {
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var biography: String
    @NSManaged public private(set) var lecture: Lecture
    
    static func insert(into context: NSManagedObjectContext,
                       name: String,
                       shortBio: String) {
        
        context.perform {
            let lecturer: Lecturer = context.insertObject()
            lecturer.name = name
            lecturer.biography = shortBio
            _ = context.saveOrRollback()
            
        }
    }
    
    static func findOrCreateLecturer (
        with lecturerName: String,
        lecturerBio: String,
        into context: NSManagedObjectContext) -> Lecturer {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(name), lecturerName)
        let lecturer = findOrCreate(in: context, matching: predicate) {
            $0.name = lecturerName
            $0.biography = lecturerBio
        }
        return lecturer
    }
}


extension Lecturer: Managed{
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(name), ascending: false)]
    }
}
