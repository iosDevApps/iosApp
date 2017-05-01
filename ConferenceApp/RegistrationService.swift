//
//  RegistrationService.swift
//  ConferenceApp
//
//  Created by matej on 5/1/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class RegistrationService : BaseService{
    
    
    func register(email: String, password: String,firstName: String, lastName: String, age: Int,gendre: String  )-> Observable<Bool> {
        
        print("register")
        
        return Observable.create({ (observer) -> Disposable in
        
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                
                var request = URLRequest(url: URL(string: super.BASE_URL+"/auth/register")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                let parameters = ["username": email as AnyObject,
                                  "password": password as AnyObject,
                                  "first_name": firstName as AnyObject,
                                  "last_name": lastName as AnyObject,
                                  "age" : age as AnyObject,
                                  "gender" : gendre as AnyObject] as Dictionary<String, AnyObject>
                
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
                        
                        let user = UserJson(json: json)
                        print("user ", user ?? "")
                        
                        observer.onNext(true)
                        observer.onCompleted()
                        
                    }catch let error as NSError{
                        print(error)
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }).resume()
            }
        
         return Disposables.create()
    })
    }
}
