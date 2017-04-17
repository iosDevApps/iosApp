//
//  ProfileService.swift
//  ConferenceApp
//
//  Created by Admin on 15/04/2017.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation

class ProfileService {
    private var handler: (UserJson) -> Void = { user in }
    
    func getUser(handler: @escaping (UserJson) -> Void) {
        self.handler = handler
        let jsonService = JsonService()
        jsonService.get(url: "http://138.68.104.189/users", handler: handleData)
    }
    
    private func handleData(data: Data) {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            let json = parsedData[0]
            
            guard let user = UserJson(json: json) else {
                return
            }
            
            handler(user)
        } catch {
            print(error)
        }
    }
    
}
