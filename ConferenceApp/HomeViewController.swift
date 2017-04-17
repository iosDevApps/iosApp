//
//  HomeViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eventButtonTouched(_ sender: UIButton) {
        let persistanceService = PersistanceService()
        let scheduleViewController = ScheduleViewController(persistanceService: persistanceService)
        navigationController?.pushViewController(scheduleViewController, animated: true)

    }
    
    @IBAction func coreDataTest(_ sender: UIButton) {
        let persistanceService = PersistanceService()
        let eventsViewController = EventsViewController(persistanceService: persistanceService)
        navigationController?.pushViewController(eventsViewController, animated: true)

    }

    @IBAction func profileTap(_ sender: UIButton) {
        let profileService = ProfileService()
        let profileViewController = ProfileViewController(profileService: profileService)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
