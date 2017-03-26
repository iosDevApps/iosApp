//
//  ScheduleViewController.swift
//  ConferenceApp
//
//  Created by luka on 23/03/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class ScheduleViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private var schedule: Schedule?
    private var dailySchedules = [DailyScheduleViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false

        self.schedule = createScheduleFromJson()
        
        createDailySchedulesArray()

        self.delegate = self
        self.dataSource = self
        
//        if let schedule = schedule, let firstDay = schedule.lecturesSchedule.keys.first {
//            let firstDayViewController = DailyScheduleViewController(
//                lectures: schedule.lecturesSchedule[firstDay]!,
//                date: firstDay,
//                navigationBarHeight: 44
//            )
//            setViewControllers([firstDayViewController], direction: .forward, animated: true, completion: nil)
//        }

        if let viewController = dailySchedules.first {
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    

    private func createDailySchedulesArray() {
        
        let sortedKeys = Array(schedule!.lecturesSchedule.keys).sorted(by: <)
        let height = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height

        for key in sortedKeys {
            let dailySchedule = DailyScheduleViewController(lectures: (schedule?.lecturesSchedule[key])!, date: key, navigationBarHeight: height)
            self.dailySchedules.append(dailySchedule)
        }
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