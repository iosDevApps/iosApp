//
//  RegistrationViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum Gendre:String {
    case MAN = "Man"
    case WOMAN = "Woman"
    case Unknown = "Unknownd"
}

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var usernameValue: UITextField!
    @IBOutlet weak var passwordValue: UITextField!
    @IBOutlet weak var firstNameValue: UITextField!
    @IBOutlet weak var lastNameValue: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
  
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var gendreChooser: UISegmentedControl!
    @IBOutlet weak var registerBtn: UIButton!
    
    var loginService: LoginService!
    var persistService: PersistService!
    
    var viewModel : RegistrationViewModel!
    private let disposeBag = DisposeBag()
    
    
    @IBAction func sliderAgeAction(_ sender: Any) {
        ageValueLabel.text =  Int(ageSlider.value).description
    }
    
    convenience init(loginService: LoginService, persistService: PersistService){
        self.init()
        self.loginService = loginService
        self.persistService = persistService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RegistrationViewModel(registerService: RegistrationService(), persistService: persistService)
        
        bindInputs();
        bindOutputs();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.usernameValue.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.passwordValue.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.firstNameValue.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.lastNameValue.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.ageValueLabel.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.gendreChooser.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        
        self.usernameLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        self.passwordLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        self.firstNameLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        self.lastNameLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        self.ageLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        self.genderLabel.transform = CGAffineTransform.identity.translatedBy(x: -view.frame.width/2, y: 0)
        
        self.ageSlider.alpha = 0
        self.registerBtn.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.usernameValue.transform = CGAffineTransform.identity
            self.passwordValue.transform = CGAffineTransform.identity
            self.firstNameValue.transform = CGAffineTransform.identity
            self.lastNameValue.transform = CGAffineTransform.identity
            self.ageValueLabel.transform = CGAffineTransform.identity
            self.gendreChooser.transform = CGAffineTransform.identity
            
            self.usernameLabel.transform = CGAffineTransform.identity
            self.passwordLabel.transform = CGAffineTransform.identity
            self.firstNameLabel.transform = CGAffineTransform.identity
            self.lastNameLabel.transform = CGAffineTransform.identity
            self.ageLabel.transform = CGAffineTransform.identity
            self.genderLabel.transform = CGAffineTransform.identity
            
            self.usernameValue.alpha = 1
            self.passwordValue.alpha = 1
            self.firstNameValue.alpha = 1
            self.lastNameValue.alpha = 1
            self.ageValueLabel.alpha = 1
            self.gendreChooser.alpha = 1
            
            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.registerBtn.alpha = 1
            self.ageSlider.alpha = 1
        }
        )
    }

    
    func bindInputs(){
        (usernameValue.rx.textInput <-> viewModel.email).addDisposableTo(disposeBag)
        (passwordValue.rx.textInput <-> viewModel.password).addDisposableTo(disposeBag)
        (firstNameValue.rx.textInput <-> viewModel.firstName).addDisposableTo(disposeBag)
        (lastNameValue.rx.textInput <-> viewModel.lastName).addDisposableTo(disposeBag)
        
        let age = ageSlider.rx.value
        age.asObservable().bindTo(viewModel.age).addDisposableTo(disposeBag)
        
        let gendre = gendreChooser.rx.value
        gendre.asObservable().map{ value in
            switch(value){
                case 0:
                    return Gendre.MAN.rawValue
                case 1:
                    return Gendre.WOMAN.rawValue
                default:
                    return Gendre.Unknown.rawValue
            }
        }.bindTo(viewModel.gendre).addDisposableTo(disposeBag)
        
        registerBtn.rx.tap.bindTo(viewModel.registerTap)
        .addDisposableTo(disposeBag)
    }
    
    func bindOutputs(){
        
        viewModel.isRegisterButtonEnabled
                .drive(registerBtn.rx.isEnabled)
                .addDisposableTo(disposeBag)

        viewModel.registerSuccess
            .drive(onNext:{
                print("registration success")
                self.openHomeViewController()
            }).addDisposableTo(disposeBag)
    }
    
    
    func openHomeViewController(){
        let vc = HomeViewController(loginService: loginService, persistService:persistService);
        navigationController?.pushViewController(vc, animated: true)
    }

}
