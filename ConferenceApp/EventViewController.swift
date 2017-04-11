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

class EventViewController: UIViewController {
    
    fileprivate var persistanceService: PersistanceService? = nil
    
    var tableView = UITableView()
    fileprivate var dataSource: TableViewDataSource<EventViewController>?
    private var schedule: Schedule?

    convenience init(persistanceService: PersistanceService?) {
        self.init()
        self.persistanceService = persistanceService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        schedule = createScheduleFromJson()
//        persitanceService!.createEvent(withEventId: Int16(schedule!.eventId), days: Int16(schedule!.scheduleDuration), schedule: schedule!) { event in
//            print("photo created", event.eventId)
//        }
        setupTableView()
        
        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func setupTableView() {
        
        let identifier = String(describing: EventTableViewCell.self)
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        let request = EventSchedule.sortedFetchRequest
        request.fetchBatchSize = 20
        if let frc = persistanceService?.fetchController(forRequest: request) {
            dataSource = TableViewDataSource(tableView: tableView,
                                             cellIdentifier: identifier,
                                             fetchedResultsController: frc,
                                             delegate: self)
        }
        tableView.delegate = self
        
    }
    
    private func createScheduleFromJson() -> Schedule? {
        
        let jsonFileName = "untitled"
        
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    let schedule = Schedule(json: parsedData)
                                        
                    return schedule
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return nil
    }
    
}

extension EventViewController: TableViewDataSourceDelegate {
    func configure(_ cell: EventTableViewCell, for object: EventSchedule) {
        cell.configure(for: object)
    }
    
    func deleteAction(for object: EventSchedule) {
        persistanceService?.delete(event: object)
    }
}

extension EventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let object = dataSource?.objectAtIndexPath(indexPath)
        persistanceService!.delete(event: object!)
    }
}
