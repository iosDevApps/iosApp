//
//  ScheduleViewController.swift
//  ConferenceApp
//
//  Created by luka on 23/03/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class ScheduleViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private var event: EventJson?
    private var persistanceService: PersistanceService?
    private var dateKeys: [String] = []

    convenience init(persistanceService: PersistanceService?) {
        self.init()
        self.persistanceService = persistanceService
        self.event = createEventFromJson()
        self.dateKeys = createDateArray()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarViewSetUp()
        view.backgroundColor = .white

        self.delegate = self
        self.dataSource = self
        
        pageViewControllerSetUp()
    }
    
    private func createDailySchedule(lectures: [LectureJson], date: String) -> DailyScheduleViewController {
        return DailyScheduleViewController(lectures: lectures, date: date)
    }
    
    private func pageViewControllerSetUp() {
        let schedule = event!.schedule
        let viewController = createDailySchedule(lectures: schedule.lecturesSchedule[dateKeys[0]]!, date: dateKeys[0])
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func navigationBarViewSetUp () {
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.title = "Schedule"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveEvent))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    @objc private func saveEvent() {
        persistanceService!.createEvent(
            withEventId: event!.eventId,
            eventName: event!.eventName,
            eventDuration: Int16(event!.eventDuration))
        { event in
            print("event ID:", event.eventId)
        }
    }
    
    
    private func createDateArray() -> [String] {
        let schedule = self.event?.schedule
        return Array(schedule!.lecturesSchedule.keys).sorted(by: <)
    }
    
    private func createEventFromJson() -> EventJson? {
        
        let jsonFileName = "untitled"
        
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    let event = EventJson(json: parsedData)
                    return event
                    
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let controller = viewController as! DailyScheduleViewController
        let dailyScheduleViewControllerIndex = self.dateKeys.index(of: controller.date)
        let previousViewControllerIndex = dailyScheduleViewControllerIndex! - 1

        guard previousViewControllerIndex>=0 else {
            return nil
        }
        guard dateKeys.count >= previousViewControllerIndex else {
            return nil
        }
        
        let schedule = event!.schedule 
        return createDailySchedule(
            lectures: schedule.lecturesSchedule[dateKeys[previousViewControllerIndex]]!,
            date: dateKeys[previousViewControllerIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let controller = viewController as! DailyScheduleViewController
        let dailyScheduleViewControllerIndex = self.dateKeys.index(of: controller.date)
        let nextViewControllerIndex = dailyScheduleViewControllerIndex! + 1
        
        guard nextViewControllerIndex < dateKeys.count else {
            return nil
        }
        guard dateKeys.count >= nextViewControllerIndex else {
            return nil
        }
        
        let schedule = event!.schedule
        return createDailySchedule(
            lectures: schedule.lecturesSchedule[dateKeys[nextViewControllerIndex]]!,
            date: dateKeys[nextViewControllerIndex])
    }
    
}
