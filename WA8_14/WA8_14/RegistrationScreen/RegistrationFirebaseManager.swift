//
//  RegistrationFirebaseManager.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation
import UIKit
import FirebaseAuth

extension RegistrationViewController {
    
    func registerNewAccount() {
        
        if let name = registerView.nameTextField.text,
               let email = registerView.emailTextField.text,
               let password = registerView.passwordTextField.text {
                   Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                       if error == nil {
                           self.setUserNameInFirebaseAuth(name: name)
                       }
                       else {
                           print(error)
                           self.showErrorAlert(message: (error?.localizedDescription.description)!)
                       }
                   })
               }
    }
    
    func setUserNameInFirebaseAuth(name: String) {
        
        showActivityIndicator()
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil {
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print(error)
                self.showErrorAlert(message: (error?.localizedDescription.description)!)
            }
        })
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
