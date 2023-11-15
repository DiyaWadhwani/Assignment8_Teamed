//
//  RegistrationViewController.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    let registerView = RegistrationView()
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.registerButton.addTarget(self, action: #selector(attemptUserRegistration), for: .touchUpInside)
        
    }
    
    @objc func attemptUserRegistration() {
        registerNewAccount()
    }
    


}
