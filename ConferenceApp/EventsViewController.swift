//
//  EventsViewController.swift
//  ConferenceApp
//
//  Created by luka on 22/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import PureLayout

fileprivate let reusableIdentifier = String(describing: EventTableViewCell.self)

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    private var events = [EventJson]()
    private var eventService: EventService?
    private var schedule: ScheduleJson?
    private var scheduleService: ScheduleService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventService?.getEvents(handler: loadEvents)
        setUpTable()
    }
    
    func loadEvents(events: [EventJson]) {
        DispatchQueue.main.async {
            self.events = events
            self.tableView.reloadData()
        }
        
    }
    
    func loadSchedule(schedule: ScheduleJson) {
        DispatchQueue.main.async {
            self.schedule = schedule
        }
    }
    
    convenience init(eventService: EventService, scheduleService: ScheduleService) {
        self.init()
        self.eventService = eventService
        self.scheduleService = scheduleService
    }
    
    
    private func setUpTable() {
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! EventTableViewCell
        cell.configure(for: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let scheduleService = ScheduleService()
        let persistanceService = PersistanceService()
        let scheduleViewController = ScheduleViewController(persistanceService: persistanceService,
                                                            event: event,
                                                            scheduleService: scheduleService)
        
        self.navigationController?.pushViewController(scheduleViewController, animated: true)
        
    }
    
}
