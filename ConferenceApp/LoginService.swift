//
//  LoginService.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift

class LoginService {
    
    func login(email: String, password: String) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                observer.onNext(password == "password")
                observer.onCompleted()
            }
            return Disposables.create()
        })    }
    
}
