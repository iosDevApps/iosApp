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

class RegistrationViewController: UIViewController {
   
    @IBOutlet weak var usernameValue: UITextField!
    @IBOutlet weak var passwordValue: UITextField!
    @IBOutlet weak var firstNameValue: UITextField!
    @IBOutlet weak var lastNameValue: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
  
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var gendreChooser: UISegmentedControl!
    @IBOutlet weak var registerBtn: UIButton!
    
    var viewModel : RegistrationViewModel!
    private let disposeBag = DisposeBag()
    
    
    @IBAction func sliderAgeAction(_ sender: Any) {
        ageValueLabel.text =  Int(ageSlider.value).description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RegistrationViewModel(registerService: RegistrationService(), persistService: PersistService())
       
        
        bindInputs();
        bindOutputs();
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
            if(value==0){
                return "Man"
            }else if(value==1){
                return "Woman"
            }else{
                return "Unknown"
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
        let vc = HomeViewController();
        navigationController?.pushViewController(vc, animated: true)
    }

}
