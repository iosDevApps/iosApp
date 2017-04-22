//
//  Lecturer.swift
//  ScheduleApp
//
//  Created by luka on 17/03/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit

class UserJson {
    let firstName: String
    let lastName: String
    let gender: String
    let age: Int
    //let image: UIImage
    
    init?(json: [String: Any]) {
        print(json)
        guard let firstName = json["first_name"] as! String?,
            let lastName = json["last_name"] as! String?,
            let gender = json["gender"] as! String?,
            let age = json["age"] as! Int?
            else {
                return nil
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.age = age
        
        /*guard let imageURLString = json["profile_image"] as! String?,
            let imageURL = URL(string: imageURLString),
            let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data)
            else {
                return nil
        }
        
        self.image = image*/
    }
}
