//
//  RightBarButtonManager.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation
import UIKit
import FirebaseAuth

extension ViewController {
    
    func setupRightBarButton(isLoggedIn: Bool) {
        
        if isLoggedIn {
            
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                style: .plain,
                target: self,
                action: #selector(attemptUserLogout)
            )
            
            let barText = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(attemptUserLogout)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
        }
        
        else {
            
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "person.fill.questionmark"),
                style: .plain,
                target: self,
                action: #selector(attemptUserLogin)
            )
            
            let barText = UIBarButtonItem(
                title: "Sign in",
                style: .plain,
                target: self,
                action: #selector(attemptUserLogin)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
            
        }
    }
    
    @objc func attemptUserLogout() {
        
        let logoutAlert = UIAlertController(title: "Logging Out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(_) in
            do {
                try Auth.auth().signOut()
            }
            catch {
                print("Error while signing out")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
        
    }
    
    @objc func attemptUserLogin() {
        
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue",
            preferredStyle: .alert
        )
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Enter Email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        signInAlert.addTextField { textField in
            textField.placeholder = "Enter Password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {(_) in
            if let email = signInAlert.textFields![0].text,
               let password = signInAlert.textFields![1].text {
                
                self.signInToFirebase(email: email, password: password)
                
            }
        })
        
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
            print("New user registration")
            
            let registrationController = RegistrationViewController()
            self.navigationController?.pushViewController(registrationController, animated: true)
        })
        
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true, completion: {() in
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
        
    }
    
    @objc func onTapOutsideAlert() {
        self.dismiss(animated: true)
    }
    
    func signInToFirebase(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            
            if error == nil {
                print("user authenticated")
                self.setupRightBarButton(isLoggedIn: true)
            }
            else {
                print(error)
                self.showErrorAlert(message: "Invalid Username or Password. Please try again")
            }
        })
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
