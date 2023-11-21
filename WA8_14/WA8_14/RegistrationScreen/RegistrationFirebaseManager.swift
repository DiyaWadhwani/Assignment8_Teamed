//
//  RegistrationFirebaseManager.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation
import UIKit
import FirebaseAuth
import CryptoKit

extension RegistrationViewController {
    
    func registerNewAccount(_ name: String, _ email: String, _ password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
            
            if error == nil {
                
                self.currentUser = result?.user
                let userID = self.currentUser!.uid
                
                //update userName
                self.setUserNameInFirebaseAuth(name: name)
            }
            else {
                print(error)
                self.showErrorAlert(message: (error?.localizedDescription.description)!)
            }
        })
    }
    
    func setUserNameInFirebaseAuth(name: String) {
        
        showActivityIndicator()
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        changeRequest?.commitChanges(completion: {(error) in
            
            if error == nil {
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
        
        if let userEmail = currentUser?.email {
            
            let data = ["name": currentUser?.displayName ?? "", "email": userEmail]
            let userCollection = database.collection("users")
            
            userCollection.document(userEmail).setData(data) { error in
                
                if let error = error {
                    print("Error creating userCollection: \(error.localizedDescription)")
                } else {
                    print("userCollection created successfully")
                    
                    //fetch userCollectionCount after creating the "users" collection
                    userCollection.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching userCollection documents: \(error.localizedDescription)")
                        } else {
                            userCollectionCount = querySnapshot?.documents.count ?? 0
                            print("No. of documents in users collection: \(userCollectionCount)")
                            
                            //checking number of users in userCollection
                            if userCollectionCount > 1 {
                                
                                //fetch emails of users in userCollection
                                var userEmailList = querySnapshot?.documents.compactMap { document in
                                    document.data()["email"] as? String
                                } ?? []
                            }
                        }
                    }
                }
            }
            
            hideActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
