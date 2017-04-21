	//
//  LoginViewController.swift
//  ConferenceApp
//
//  Created by matej on 3/20/17.
//  Copyright © 2017 matej. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel : LoginViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtils.setBackground(view : self.view,image: AssetImage.city)
        
        viewModel = LoginViewModel(loginService: LoginService(), persistService: PersistService())
        
        activityIndicatorView.startAnimating()

        bindInputs()
        bindOutputs()
        
        
        /* too slow :(
        DispatchQueue.global().async{
            DispatchQueue.main.async(){
            
                self.viewModel.checkIfOldUser(completion: {
                    isOldUser in
            
                    if(isOldUser){
                        self.openHomeViewController()
                    }
                })
            }
        }
     */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func bindInputs(){
        (emailTextField.rx.textInput <-> viewModel.email).addDisposableTo(disposeBag)
        (passwordTextField.rx.textInput <-> viewModel.password).addDisposableTo(disposeBag)

        loginBtn.rx.tap.bindTo(viewModel.loginTap).addDisposableTo(disposeBag)
    }
    
    func bindOutputs(){
        viewModel.isLoginButtonEnabled
            .drive(loginBtn.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        
        viewModel.errorMessage
            .drive(errorLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        //set password background to red if wrong
        viewModel.errorMessage
            .map { $0.isEmpty ?  UIColor.white : UIColor.red }
            .drive(onNext: { self.passwordTextField.backgroundColor = $0 })
            .addDisposableTo(disposeBag)

        
        //username
        viewModel.errorMessage
            .map{$0.isEmpty}
            .drive(errorLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.showSpinner
            .map{!$0}
            .drive(activityIndicatorView.rx.isHidden)
            .addDisposableTo(disposeBag)
     
        
        viewModel.isEmailFieldEnabled
            .drive(emailTextField.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.isPasswordFieldEnabled
            .drive(passwordTextField.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.loginSuccess
            .drive(onNext:{
                print("Login success")
                self.openHomeViewController()
            }).addDisposableTo(disposeBag)
    }
    
    func openHomeViewController(){
        let vc = HomeViewController();
        navigationController?.pushViewController(vc, animated: true)
    }

    

}
