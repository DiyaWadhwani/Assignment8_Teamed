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
        
        if let userEmail = currentUser?.email {
            let data = ["name": currentUser?.displayName ?? "", "email": userEmail]
            
            let userCollection = database.collection("users")
            
//            let chatCollection = database.collection("chats")
            
            userCollection.document(userEmail).setData(data) { error in
                if let error = error {
                    print("Error creating userCollection: \(error.localizedDescription)")
                } else {
                    print("userCollection created successfully")
                    
                    // Fetch userCollectionCount after creating the "users" collection
                    userCollection.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching userCollection documents: \(error.localizedDescription)")
                        } else {
                            userCollectionCount = querySnapshot?.documents.count ?? 0
                            print("No. of documents in users collection: \(userCollectionCount)")
                            
                            // Check if userCollectionCount > 1 and proceed
                            if userCollectionCount > 1 {
                                // Continue with the logic for the "chats" collection
                                var userEmailList = querySnapshot?.documents.compactMap { document in
                                    document.data()["email"] as? String
                                } ?? []
                                print(userEmailList)
                                
//                                if let currentUserEmail = self.currentUser?.email {
//                                    //                                    userEmailList.removeAll { $0 == currentUserEmail }
//                                    //                                }
//                                    
//                                    //                                print("Email List after removing logged in user: \(userEmailList)")
//                                    
//                                    // Now explicitly create the "chats" collection
//                                    if(userEmailList.isEmpty){
//                                        chatCollection.document(currentUser)
//                                    }
//                                    else{
//                                        for email in userEmailList {
//                                            chatCollection.document(email).setData(["email": email])
//                                        }
//                                    }
//                                }
                            }
                        }
                    }
                }
            }
            
            hideActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createChatCollectionForUser(_ emailList: [String]) {
        print("creating chat collection for user email \(self.currentUser!.email) with emails \(emailList)")
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
