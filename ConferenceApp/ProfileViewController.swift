//
//  ProfileViewController.swift
//  ConferenceApp
//
//  Created by Admin on 13/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileService: ProfileService?
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    convenience init(profileService: ProfileService?) {
        self.init()
        
        self.profileService = profileService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileService?.getUser(handler: loadUser)
    }
    
    func loadUser(user: UserJson) {
        DispatchQueue.main.async {
            print(user.firstName)
            print(user.lastName)
            print(user.gender)
            print(user.age)
            self.userName.text = user.firstName + " " + user.lastName
            self.userGender.text = user.gender == "M" ? "Male" : "Female"
            self.userAge.text = String(user.age)
            //userImage.image = user.image
        }
    }
}
