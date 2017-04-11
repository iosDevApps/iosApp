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
    private var dailySchedules = [DailyScheduleViewController]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarViewSetUp()
        view.backgroundColor = .white
        
        self.event = createEventFromJson()
        createDailySchedulesArray()

        self.delegate = self
        self.dataSource = self
        

        if let viewController = dailySchedules.first {
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
        
        
    }
    

//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private func navigationBarViewSetUp () {
        
        self.edgesForExtendedLayout = []
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.title = "Schedule"
    }
    
    

    private func createDailySchedulesArray() {
        
        let schedule = self.event?.schedule
        let sortedKeys = Array(schedule!.lecturesSchedule.keys).sorted(by: <)

        for key in sortedKeys {
            let dailySchedule = DailyScheduleViewController(lectures: (schedule?.lecturesSchedule[key])!, date: key)
            self.dailySchedules.append(dailySchedule)
        }
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
        
        let dailyScheduleViewControllerIndex = self.dailySchedules.index(of: controller)
        
        let previousViewControllerIndex = dailyScheduleViewControllerIndex! - 1

        guard previousViewControllerIndex>=0 else {
            return nil
        }
        
        guard dailySchedules.count >= previousViewControllerIndex else {
            return nil
        }
        
        return dailySchedules[previousViewControllerIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // todo: mairati viewModele na viewController kao u viewDidLoadu
        
        let controller = viewController as! DailyScheduleViewController
        
        let dailyScheduleViewControllerIndex = self.dailySchedules.index(of: controller)
        
        let nextViewControllerIndex = dailyScheduleViewControllerIndex! + 1
        
        guard nextViewControllerIndex < dailySchedules.count else {
            return nil
        }
        
        guard dailySchedules.count >= nextViewControllerIndex else {
            return nil
        }
        
        return dailySchedules[nextViewControllerIndex]
    }
    
}
