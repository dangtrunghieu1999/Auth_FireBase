//
//  ViewController.swift
//  EmailPasswordLogin
//
//  Created by Dang Trung Hieu on 9/4/20.
//  Copyright © 2020 Dang Trung Hieu. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24,weight: .semibold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.autocapitalizationType = .none
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginLabel.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        
        emailTextField.frame = CGRect(x: 20,
                                      y:loginLabel.frame.origin.y + loginLabel.frame.size.height + 10,
                                      width:view.frame.size.width - 40,
                                      height: 50)
        
        passwordTextField.frame = CGRect(x: 20,
                                         y: emailTextField.frame.origin.y + emailTextField.frame.size.height + 10,
                                         width:view.frame.size.width - 40,
                                         height: 50)
        
        continueButton.frame = CGRect(x: 20,
                                      y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 50,
                                      width:view.frame.size.width - 40,
                                      height: 52)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    @objc private func didTapButton() {
        print("touchhh")
        
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                print("Missing data field")
                return
        }
        
        // get auth instance
        // attempt sign In
        // if failure, present alert to create account
        // if user continues, create account
        
        // check sign in on app lauch
        // allow user to sign out with button
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](result, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            
            
            guard error == nil else {
                // show account creation
                
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("you have signed in")
            strongSelf.loginLabel.isHidden = true
            strongSelf.emailTextField.isHidden = true
            strongSelf.passwordTextField.isHidden = true
            strongSelf.continueButton.isHidden = true
            strongSelf.emailTextField.resignFirstResponder()
            strongSelf.passwordTextField.resignFirstResponder()
        }
        
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: { (_) in
                                        
                                        Auth.auth().createUser(withEmail: email, password: password) { [weak self](result, error) in
                                            
                                            guard let strongSelf = self else {
                                                return
                                            }
                                            guard error == nil else {
                                                print("Account create failed")
                                                return
                                            }
                                            print("you have signed in")
                                            strongSelf.loginLabel.isHidden = true
                                            strongSelf.emailTextField.isHidden = true
                                            strongSelf.passwordTextField.isHidden = true
                                            strongSelf.continueButton.isHidden = true
                                        }
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { (_) in
        }))
        
        present(alert,animated: true)
        
    }
    
}

