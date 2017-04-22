//
//  HomeViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import PureLayout

fileprivate let reusableIdentifier = String(describing: EventTableViewCell.self)

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var events: [EventJson]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init() {
        
        self.events = HomeViewController.createEventsFromJson()
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setUpTable() {
        
        self.edgesForExtendedLayout = []
        
        let tableView = UITableView()
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

}
