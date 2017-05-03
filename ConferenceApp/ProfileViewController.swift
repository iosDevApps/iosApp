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
    @IBOutlet weak var imageURL: UITextField!
    @IBOutlet weak var addImage: UIButton!
    
    convenience init(profileService: ProfileService?) {
        self.init()
        
        self.profileService = profileService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageURL.isHidden = true
        addImage.isHidden = true
        
        loadUser()
    }
    
    func loadUser() {
        if let user = ProfileService.getUser() {
            DispatchQueue.main.async {
                self.userName.text = user.firstName + " " + user.lastName
                self.userGender.text = user.gender == "M" ? "Male" : "Female"
                self.userAge.text = String(user.age)
                self.setImage(imageURLString: user.image)
            }
        }
    }
    
    @IBAction func addImageTap(_ sender: UIButton) {
        guard let imageURLString = self.imageURL.text else {
            print("Please set the image URL before adding")
            return
        }
        
        setImage(imageURLString: imageURLString)
    }
    
    private func setImage(imageURLString: String) {
        
        
        guard let imageURL = URL(string: imageURLString),
            let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data)
        else {
            self.imageURL.isHidden = false
            self.addImage.isHidden = false
            self.userImage.isHidden = true
            return
        }
        
        guard let user = ProfileService.getUser() else{
            return
        }
        
        if user.image == "" {
            let service = ProfileService()
            service.setImage(image: imageURLString)
        }
            
        
        
        self.userImage.isHidden = false
        self.imageURL.isHidden = true
        self.addImage.isHidden = true
        self.userImage.image = image
    }
}
