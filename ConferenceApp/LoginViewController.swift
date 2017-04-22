//
//  LoginViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
@IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setClickListeners()
    }


    func setClickListeners(){
        loginBtn.addTarget(self, action: #selector(checkLogin), for: .touchUpInside)
    }
    

    func checkLogin(){
        openHomeViewController()
    }
    
    func openHomeViewController(){
        
        let persistanceService = PersistanceService()
        let eventsViewController = EventsViewController(persistanceService: persistanceService)

        let vc = HomeViewController();
        navigationController?.pushViewController(eventsViewController, animated: true)
    }

}
