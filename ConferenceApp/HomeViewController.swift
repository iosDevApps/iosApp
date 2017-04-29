//
//  HomeViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import PureLayout

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {

        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false

        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = createViewControllers()
        self.navigationItem.title = self.selectedViewController!.title        
    }
    
    private func createViewControllers() -> [UIViewController] {
        let profileService = ProfileService()
        let persistanceService = PersistanceService()
        let eventService = EventService()
        
        let favoriteEventsViewController = FavoriteEventsViewController(persistanceService: persistanceService)
        favoriteEventsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favoriteEventsViewController.title = "Favorites"
        
        let eventsViewController = EventsViewController(eventService: eventService)
        eventsViewController.tabBarItem = UITabBarItem(title: "Events", image: nil, tag: 2)
        eventsViewController.title = "Upcoming Events"
        
        let profileViewController = ProfileViewController(profileService: profileService)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 3)
        profileViewController.title = "Profile"
        
        let viewControllers = [favoriteEventsViewController, eventsViewController, profileViewController]
        
        return viewControllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.navigationItem.title = viewController.title
    }
    
}


//class HomeViewController: UIViewController {
//
//    override func viewDidLoad() {
//
//        let profileService = ProfileService()
//        let persistanceService = PersistanceService()
//        let tabBarViewController = UITabBarController()
//        let favoriteEventsViewController = FavoriteEventsViewController(persistanceService: persistanceService)
//        let eventsViewController = EventsViewController()
//        let profileViewController = ProfileViewController(profileService: profileService)
//        let viewControllers = [favoriteEventsViewController, eventsViewController, profileViewController]
//
//        tabBarViewController.viewControllers = viewControllers
//
//
//        super.viewDidLoad()
////        setUpTable()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    @IBAction func profileTap(_ sender: UIButton) {
//        let profileService = ProfileService()
//        let profileViewController = ProfileViewController(profileService: profileService)
//        navigationController?.pushViewController(profileViewController, animated: true)
//    }
//}
