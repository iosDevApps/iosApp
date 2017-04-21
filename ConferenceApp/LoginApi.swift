//
//  LoginApi.swift
//  ConferenceApp
//
//  Created by matej on 4/21/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit


class LoginApi {
    let username: String
    let password : String
    
    init?(json: [String: Any]) {
        print("Login json: ", json)
        guard
            let username = json["username"] as? String,
            let password = json["password"] as? String
            else {
                return nil
        }
        
        self.username = username
        self.password = password
        
    }
}
