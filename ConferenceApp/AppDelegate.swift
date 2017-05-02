//
//  AppDelegate.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let rc = LoginViewController(loginService: LoginService(), persistService: PersistService())
        
        window = UIWindow(frame:UIScreen.main.bounds)
        let nc = UINavigationController(rootViewController:rc)
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }


}

