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
    
    var loginService: LoginService!
    var persistService: PersistService!
    
    var viewModel : LoginViewModel!
    private let disposeBag = DisposeBag()
    
    convenience init(loginService: LoginService, persistService: PersistService){
        self.init()
        self.loginService = loginService
        self.persistService = persistService
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtils.setBackground(view : self.view,image: AssetImage.city)
    
        viewModel = LoginViewModel(loginService: loginService, persistService: persistService)
        
        activityIndicatorView.startAnimating()
        
        bindInputs()
        bindOutputs()
        
        
        /* too slow :(
         when user open app should chech if user already exists and if exists send him imediately to home screen
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
        
        registerBtn.addTarget(self, action: #selector(openRegistrationViewController), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        self.emailTextField.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.passwordTextField.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.registerBtn.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.emailTextField.transform = CGAffineTransform.identity
            self.passwordTextField.transform = CGAffineTransform.identity
           
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
            
            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.registerBtn.alpha=1
        }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func bindInputs(){
        (emailTextField.rx.textInput <-> viewModel.email).addDisposableTo(disposeBag)
        (passwordTextField.rx.textInput <-> viewModel.password).addDisposableTo(disposeBag)

        loginBtn.rx.tap.bindTo(viewModel.loginTap).addDisposableTo(disposeBag)
        
        registerBtn.rx.tap.bindTo(viewModel.registerTap).addDisposableTo(disposeBag)
    }
    
    func bindOutputs(){
        viewModel.isLoginButtonEnabled
            .map{!$0}
            .drive(loginBtn.rx.isHidden)
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
        let vc = HomeViewController(loginService: loginService, persistService:persistService);
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openRegistrationViewController(){
        let vc = RegistrationViewController(loginService: loginService, persistService: persistService);
        navigationController?.pushViewController(vc, animated: true)
    }    

}
