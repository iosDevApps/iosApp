//
//  RegistrationViewModel.swift
//  ConferenceApp
//
//  Created by matej on 5/1/17.
//  Copyright © 2017 matej. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum RegistrationResult {
    case notRegisteredIn
    case registeredIn
    case registrationInProgress
    case error
}


class RegistrationViewModel{
    
    
    //input
    let email: Variable<String>
    let password: Variable<String>
    let firstName: Variable<String>
    let lastName: Variable<String>
    let age: Variable<Float>

    let gendre: Variable<String>

    let registerTap: PublishSubject<Void>
    
    
    //Output
    let isRegisterButtonEnabled: Driver<Bool>
    let showSpinner: Driver<Bool>
    let errorMessage: Driver<String>
    
    let registerSuccess: Driver<Void>
    private let disposeBag = DisposeBag()
    
    private let registerService: RegistrationService
    private let persistService: PersistService
    
    init(registerService: RegistrationService, persistService: PersistService) {
        self.registerService = registerService
        self.persistService = persistService
        
        let email = Variable("")
        let password = Variable("")
        let firstName = Variable("")
        let lastName = Variable("")
        let age = Variable(Float(18))
        let gendre = Variable("Man")

        let registerTap = PublishSubject<Void>()
        
        let registerResult = registerTap
            .flatMapLatest { () -> Observable<RegistrationResult> in
                return registerService.register(email: email.value,
                                                password: password.value,
                                                firstName: firstName.value,
                                                lastName: lastName.value,
                                                age: Int(age.value),
                                                gendre: gendre.value
                    ).map { success in
                        
                    return success ? .registeredIn : .error
                    }.startWith(.registrationInProgress)
            }.startWith(.notRegisteredIn)
            .shareReplay(1)
        
        let registrationInProgress = registerResult.map { $0 == .registrationInProgress }

        
        self.isRegisterButtonEnabled = Observable
            .combineLatest(
            email.asObservable(),
            password.asObservable(),
            firstName.asObservable(),
            lastName.asObservable(),
            registerResult){
            
            return $0.characters.count > LoginService.EMAIL_LENGTH &&
                $1.characters.count > LoginService.PASSWORD_LENGTH &&
                $2.characters.count > 0 &&
                $3.characters.count > 0 &&
                $4 != RegistrationResult.registrationInProgress
                
            }.asDriver(onErrorJustReturn: false)
    
        self.showSpinner = registrationInProgress
            .asDriver(onErrorJustReturn: false)
        
        self.errorMessage = Observable.of(
            Observable.of(email.asObservable(), password.asObservable())
                .merge()
                .map { _ in "" }, registerResult.map { $0 == .error ? "All data are mandatory" : "" }
            ).merge()
            .asDriver(onErrorJustReturn: "")
        
        self.registerSuccess = registerResult
            .asDriver(onErrorJustReturn: .error)
            .filter { $0 == .registeredIn }
            .map { _ in () }
        
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gendre = gendre
        self.registerTap = registerTap
    }
    
}
