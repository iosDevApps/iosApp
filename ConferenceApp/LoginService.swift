//
//  LoginService.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginService: BaseService {

    public static let EMAIL_LENGTH = 3;
    public static let PASSWORD_LENGTH = 3;
    
    func login(email: String, password: String) -> Observable<Bool> {
        print("Login service")
   
        return Observable.create({ (observer) -> Disposable in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
                var request = URLRequest(url: URL(string: super.BASE_URL+"/auth/login")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let parameters = ["username": email, "password": password] as Dictionary<String, String>
            
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
                        print("user ", user)

                        observer.onNext(true)
                        observer.onCompleted()
                   
                    } catch let error as NSError{
                        print(error)
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }).resume()
            }
            return Disposables.create()
        })
    }
    
    func loginCommon(email: String, password: String, completion: @escaping  (UserJson?, Error?) -> () ) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            var request = URLRequest(url: URL(string: super.BASE_URL+"/auth/login")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let parameters = ["username": email, "password": password] as Dictionary<String, String>
            
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
                    
                    if let user = UserJson(json: json){
                        //print("user ", user.firstName)
                        completion(user, nil)
                    }else{
                        completion(nil,nil)
                    }
                    
                }catch let error as NSError{
                    print(error)
                    completion(nil, error)
                    
                }
            }).resume()
        }
    }

    
    func logout(persistService: PersistService) -> Bool {
        persistService.email = ""
        persistService.password = ""
        return true
    }

}
