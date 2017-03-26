//
//  DailyScheduleViewController.swift
//  ConferenceApp
//
//  Created by luka on 23/03/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

fileprivate let reusableCellIdentifier = String(describing: CalendarViewCell.self)

class DailyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var scheduleTableView = UITableView()
    
    private var lectures: [Lecture]
    
    private var navigatioBarHeight: CGFloat
    private var dataLabelHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    init(lectures: [Lecture], date: String, navigationBarHeight: CGFloat) {
        
        self.lectures = lectures
        self.date = date
        self.navigatioBarHeight = navigationBarHeight
        super.init(nibName: nil, bundle: nil)

        configureTable(date: date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeDateLabel(date: String) -> UILabel {
        let label = UILabel()
        label.text = date
        label.frame = CGRect(x: 0, y: self.navigatioBarHeight, width: screenWidth, height: dataLabelHeight)
        label.textAlignment = .center
        return label
    }
    
    private func configureTable(date: String) {
        scheduleTableView.register(CalendarViewCell.self, forCellReuseIdentifier: reusableCellIdentifier)
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        scheduleTableView.estimatedRowHeight = 70
        scheduleTableView.rowHeight = UITableViewAutomaticDimension
        scheduleTableView.tableFooterView = UIView()
        
        let dateLabel = makeDateLabel(date: date)
        
        scheduleTableView.frame = CGRect(x: 0, y: self.navigatioBarHeight+dataLabelHeight, width: screenWidth, height: screenHeight)
        
        
        
        self.view.addSubview(dateLabel)
        self.view.addSubview(scheduleTableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lectures.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lecture = lectures[indexPath.row]
        
        let lectureDetailViewController = LectureDetailViewController(lectureInfo: lecture)
        navigationController?.pushViewController(lectureDetailViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath) as! CalendarViewCell

        cell.backgroundColor = UIColor.cyan
        cell.textLabel!.text = lectures[indexPath.row].lectureTitle
        return cell
        
    }
    
    
}

