//
//  ProfileService.swift
//  ConferenceApp
//
//  Created by Admin on 15/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class ProfileService: BaseService {
    static let instance = ProfileService()
    
    private var user: UserJson?
    
    override init() {
        super.init()
    }
    
    public static func setUser(user: UserJson) {
        instance.user = user
    }
    
    public static func getUser() -> UserJson? {
        if let user = instance.user {
            return user
        }
        
        return nil
    }
}
