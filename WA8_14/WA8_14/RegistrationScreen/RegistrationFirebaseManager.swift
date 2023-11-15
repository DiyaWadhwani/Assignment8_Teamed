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
                    self.currentUser = result?.user
                    print(self.currentUser!.displayName)
                    print(self.currentUser!.email)
                    let userID = self.currentUser!.uid
                    print("created user with ID: \(userID)")
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
                print("Displayname updated: \(self.currentUser!.displayName)")
                self.createFirestoreUserDocument()
            }
            else {
                print(error)
                self.showErrorAlert(message: (error?.localizedDescription.description)!)
            }
        })
    }
    
    func createFirestoreUserDocument() {
        var userCollectionCount = -1
        if let userEmail = currentUser!.email {
            let data = ["name":currentUser!.displayName, "email":userEmail]
            let userCollection = database.collection("users")
            userCollection.document(userEmail).setData(data) { (error) in
                if error == nil {
                    print("userCollection created successfully")
                }
                else{
                    print(error)
                }
            }
            
            userCollection.getDocuments(completion: { (querySnapshot, error) in
                if error == nil {
                    userCollectionCount = querySnapshot?.documents.count ?? 0
                    print("No. of documents in users collection: \(userCollectionCount)")
                }
            })
            hideActivityIndicator()
            self.navigationController?.popViewController(animated: true)
            
            //                let chatCollection = database.collection("users").document(userEmail).collection("chats")
            //                for i in 1...5 {
            //                        let chatReference = database.collection("chats").document("chat\(i)")
            //                        chatCollection.document("chat\(i)").setData(["chatRef": chatReference])
            //                    }
            
        }
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
