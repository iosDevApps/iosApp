//
//  EventViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/23/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import CoreData
import PureLayout

class FavoriteEventsViewController: UIViewController {
    
    fileprivate var persistanceService: PersistanceService? = nil
    fileprivate var dataSource: TableViewDataSource<FavoriteEventsViewController>?
    fileprivate var event: EventJson?

    convenience init(persistanceService: PersistanceService?) {
        self.init()
        self.persistanceService = persistanceService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func setupTableView() {
        
        let tableView = UITableView()

        let identifier = String(describing: EventTableViewCell.self)
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        let request = Event.sortedFetchRequest
        request.fetchBatchSize = 20
        if let frc = persistanceService?.fetchController(forRequest: request) {
            dataSource = TableViewDataSource(tableView: tableView,
                                             cellIdentifier: identifier,
                                             fetchedResultsController: frc,
                                             delegate: self)
        }
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    
}

extension FavoriteEventsViewController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: Event) {
        cell.configure(for: object)
    }
    
    func deleteAction(for object: Event) {
        persistanceService?.delete(event: object)
    }
}

extension FavoriteEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let object = dataSource?.objectAtIndexPath(indexPath)
        persistanceService!.delete(event: object!)
    }
}
