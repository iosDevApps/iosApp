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
    
    public func setImage(image: String) {
        //TODO: set image in server database 
        let persistService = PersistService()
        guard let email = persistService.email,
            let password = persistService.password else {
                return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            var request = URLRequest(url: URL(string: super.BASE_URL+"/users/editImage")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let parameters = ["username": email, "password": password, "profile_image": image] as Dictionary<String, String>
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: {
                (data, response, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
                    
                    guard let user = UserJson(json: json) else {
                        print("user loading failed")
                        return
                    }
                    
                    ProfileService.setUser(user: user)
                    print("user ", user.image)
                    
                    
                } catch let error as NSError{
                    print(error)
                }
            }).resume()
        }
    }
}
