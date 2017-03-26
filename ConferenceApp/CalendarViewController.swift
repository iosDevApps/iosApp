//
//  CalendarViewController.swift
//  ScheduleApp
//
//  Created by luka on 15/03/2017.
//  Copyright © 2017 luka. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var scheduleTableView = UITableView()
    fileprivate let reusableCellIdentifier = String(describing: CalendarViewCell.self)
    
    
    private var schedule: Schedule?
    
//    var lectures: [Lecture]
//    var date: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSchedule()
        configureTable()

    }

    
    
    private func configureTable() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        scheduleTableView.register(CalendarViewCell.self, forCellReuseIdentifier: reusableCellIdentifier)
        
        scheduleTableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        scheduleTableView.estimatedRowHeight = 70
        scheduleTableView.rowHeight = UITableViewAutomaticDimension
        scheduleTableView.tableFooterView = UIView()
        
        self.view.addSubview(scheduleTableView)


    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of events per day
        
        return self.schedule!.lecturesSchedule.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        //number of days
        return schedule!.scheduleDuration!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let scheduleDates = [String](schedule!.lecturesSchedule.keys)
        let sortedKeys = Array(schedule!.lecturesSchedule.keys).sorted(by: <)
        return sortedKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath) as! CalendarViewCell
        
//        let scheduleDates = [String](schedule!.lecturesSchedule.keys)
        let sortedKeys = Array(schedule!.lecturesSchedule.keys).sorted(by: <)

        let lectureDate = sortedKeys[indexPath.section]
        let lectures = schedule!.lecturesSchedule[lectureDate]!

        cell.textLabel!.text = lectures[indexPath.row].lectureTitle
        return cell
        
    }
    
    func createSchedule() {
        
        let jsonFileName = "untitled"
        
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    let schedule = Schedule(json: parsedData)
                    
                    self.schedule = schedule
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

        
    }
    

}



















