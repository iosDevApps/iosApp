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
    
    convenience init(eventService: EventService) {
        self.init()
        self.eventService = eventService
//        self.automaticallyAdjustsScrollViewInsets = false

    }
    
//    init() {
//        
//        self.events = EventsViewController.createEventsFromJson()
//        super.init(nibName: nil, bundle: nil)
//        
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    private func setUpTable() {
        

        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()

    }
    
    static private func createEventsFromJson() -> [EventJson] {
        
        let jsonFileName = "event"
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    let events = parsedData.flatMap(EventJson.init)
                    return events
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return []
    }
    private func createScheduleFromJson() -> ScheduleJson? {
        
        let jsonFileName = "schedule"
        
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                    let schedule = ScheduleJson(scheduleInfo: parsedData)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! EventTableViewCell
        cell.configure(for: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let persistanceService = PersistanceService()
        let schedule = createScheduleFromJson()!
        let scheduleViewController = ScheduleViewController(persistanceService: persistanceService,
                                                            event: events[indexPath.row],
                                                            schedule: schedule)
        navigationController?.pushViewController(scheduleViewController, animated: true)
    }
    
    @IBAction func profileTap(_ sender: UIButton) {
        let profileService = ProfileService()
        let profileViewController = ProfileViewController(profileService: profileService)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
