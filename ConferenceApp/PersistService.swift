//
//  PersistentService.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class PersistService {
    
    private let userDefaults = UserDefaults.standard
    
    var email: String? {
        get {
            return userDefaults.string(forKey: "email")
        }
        
        set {
            userDefaults.set(newValue, forKey:"email")
        }
    }
    
    var password: String? {
        get {
            return userDefaults.string(forKey: "password")
        }
        
        set {
            userDefaults.set(newValue, forKey:"password")
        }
    }
}
