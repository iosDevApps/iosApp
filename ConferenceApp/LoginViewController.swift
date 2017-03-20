//
//  LoginViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!

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
        let vc = HomeViewController();
        navigationController?.pushViewController(vc, animated: true)
    }

}
