//
//  TableViewDataSource.swift
//  ConferenceApp
//
//  Created by luka on 10/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import CoreData


protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
    func deleteAction(for object: Object)
}

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    required init(tableView: UITableView, cellIdentifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return objectAtIndexPath(indexPath)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func reconfigureFetchRequest(_ configure: (NSFetchRequest<Object>) -> ()) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: fetchedResultsController.cacheName)
        configure(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError("fetch request failed") }
        tableView.reloadData()
    }
    
    
    // MARK: Private
    
    private let tableView: UITableView
    private let fetchedResultsController: NSFetchedResultsController<Object>
    private weak var delegate: Delegate!
    private let cellIdentifier: String
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell
            else { fatalError("Unexpected cell type at \(indexPath)") }
        delegate.configure(cell, for: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate.deleteAction(for: objectAtIndexPath(indexPath))
        }
    }
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        //        tableView.endUpdates()
    }
}
