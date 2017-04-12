//
//  PersistanceService.swift
//  ConferenceApp
//
//  Created by luka on 09/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService {
    
    private var managedModel: NSManagedObjectModel!
    private var persistanceCoordinator: NSPersistentStoreCoordinator!
    fileprivate var mainContext: NSManagedObjectContext!
    
    private var storeURL: URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return URL(fileURLWithPath: paths).appendingPathComponent("DataModel.sqlite")
    }
    
    init() {
        guard let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles) else {
            fatalError("model not found")
        }
        managedModel = model
        
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        
        persistanceCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        do {
            try persistanceCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                          configurationName: nil,
                                                          at: storeURL,
                                                          options: mOptions)
        } catch (_) {
            fatalError("failed to add persistent store")
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistanceCoordinator
        
        print("store URL:", storeURL.absoluteString)
    }
    
    func fetchController<T: NSFetchRequestResult>(forRequest request: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        guard let mainContext = mainContext else {
            fatalError("coludn't get managed context")
        }
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }

}

extension PersistanceService {
    
    func createEvent(withEventId eventId: String,
                     eventName: String,
                     eventDuration: Int16,
                     completion: @escaping (Event) -> ()) {
        guard let mainContext = mainContext else {
            fatalError("context not available")
        }
        Event.insert(into: mainContext, eventId: eventId, eventName: eventName, eventDuration: eventDuration) { event in
            completion(event)
        }
    }
    
    func delete(event: Event) {
        guard let context = event.managedObjectContext else {
            print("context not available")
            return
        }
        
        context.perform {
            context.delete(event)
            let status = context.saveOrRollback()
            print("context saved:",  status)
        }
    }
}
