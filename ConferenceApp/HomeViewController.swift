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
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileService = ProfileService()
        let persistanceService = PersistanceService()
        
        let favoriteEventsViewController = FavoriteEventsViewController(persistanceService: persistanceService)
        favoriteEventsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let eventsViewController = EventsViewController()
        eventsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 2)
        
        let profileViewController = ProfileViewController(profileService: profileService)
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
        
        let viewControllers = [favoriteEventsViewController, eventsViewController, profileViewController]
        
        self.viewControllers = viewControllers
    }
    
    // UITabBarControllerDelegate method
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
//    }
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
