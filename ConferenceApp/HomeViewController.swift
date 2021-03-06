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
   
    var loginService: LoginService!
    var persistService: PersistService!
    
    convenience init(loginService: LoginService, persistService: PersistService){
        self.init()
        self.loginService = loginService
        self.persistService = persistService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let logoutButton = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.onLogoutClicked))

        self.navigationItem.rightBarButtonItem = logoutButton
        self.delegate = self
    }
    
    func onLogoutClicked(){
        let alert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("logout")
            if (self.loginService.logout(persistService: self.persistService)){
                let vc = LoginViewController(loginService: self.loginService, persistService: self.persistService);
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("Gave up from logout")
        }))
        self.present(alert, animated: true, completion: nil)
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
        let scheduleService = ScheduleService()
        
        let favoriteEventsViewController = FavoriteEventsViewController(persistanceService: persistanceService)
        favoriteEventsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favoriteEventsViewController.title = "Favorites"
        
        let eventsViewController = EventsViewController(eventService: eventService, scheduleService: scheduleService)
        eventsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 2)
        eventsViewController.title = "Upcoming Events"
        
        let profileViewController = ProfileViewController(profileService: profileService)
        profileViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        profileViewController.title = "Profile"
        
        let viewControllers = [favoriteEventsViewController, eventsViewController, profileViewController]
        
        return viewControllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.navigationItem.title = viewController.title
    }
    
}


