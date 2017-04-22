//
//  LoginViewModel.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // Inputs
    let email: Variable<String>
    let password: Variable<String>
    let loginTap: PublishSubject<Void>
    
    // Outputs
    let isLoginButtonEnabled: Driver<Bool>
    let showSpinner: Driver<Bool>
    let errorMessage: Driver<String>
    let isEmailFieldEnabled: Driver<Bool>
    let isPasswordFieldEnabled: Driver<Bool>

    let loginSuccess: Driver<Void>
    
    private let disposeBag = DisposeBag()
    //check with server
    private let loginService: LoginService
    //save to db
    private let persistService: PersistService

    init(loginService: LoginService, persistService: PersistService) {
        self.loginService = loginService
        self.persistService = persistService
        
        let email = Variable("")
        let password = Variable("")
        let loginTap = PublishSubject<Void>()
        
        //auto populate
        if let savedEmail = persistService.email {
            print("Load saved email: ", savedEmail)
            email.value = savedEmail
        }
        if let savedPassword = persistService.password {
            print("Load saved password: ", savedPassword)
            password.value = savedPassword
        }

        
        let loginResult = loginTap
            .flatMapLatest { () -> Observable<LoginResult> in
            return loginService.login(email: email.value, password: password.value).map { success in
                
                if(success){
                    persistService.email = email.value
                    persistService.password = password.value
                }
                
                return success ? .loggedIn : .error
                }.startWith(.loginInProgress)
            }.startWith(.notLoggedIn)
        .shareReplay(1)
        
        
        let loginInProgress = loginResult.map { $0 == .loginInProgress }
    
        
        self.isLoginButtonEnabled = Observable.combineLatest(email.asObservable(), password.asObservable(), loginResult) {
 
            return $0.characters.count > LoginService.EMAIL_LENGTH && $1.characters.count > LoginService.PASSWORD_LENGTH && $2 != LoginResult.loginInProgress
            }.asDriver(onErrorJustReturn: false)
        
        self.showSpinner = loginInProgress
            .asDriver(onErrorJustReturn: false)
        
        self.isEmailFieldEnabled = loginInProgress
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
        
        self.isPasswordFieldEnabled = loginInProgress
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
        
        self.errorMessage = Observable.of(
            Observable.of(email.asObservable(), password.asObservable())
                .merge()
                .map { _ in "" }, loginResult.map { $0 == .error ? "Wrong password" : "" }
            ).merge()
            .asDriver(onErrorJustReturn: "")
        
        self.loginSuccess = loginResult
            .asDriver(onErrorJustReturn: .error)
            .filter { $0 == .loggedIn }
            .map { _ in () }
        
        self.email = email
        self.password = password
        self.loginTap = loginTap
    }
    
    func checkIfOldUser(completion: @escaping (Bool) -> ()){
        //if data exists, try login user
        if (!email.value.isEmpty && !password.value.isEmpty) {
           loginService.loginCommon(email: email.value, password: password.value, completion:{
                success in
            
            if(success.0 != nil){
                completion(true)
            }else{
                completion(false)
            }
          
            /* 
            guard let user = success.0 else{
                return completion(false)
            }
            print(user.firstName)
            completion(true)
            */
                
            })
        }
    }

}
