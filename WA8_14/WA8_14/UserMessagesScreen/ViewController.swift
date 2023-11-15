//
//  ViewController.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    let userMessageView = UserMessagesView()
    var messageList = [Message]()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    
//    let database = Firestore.firestore()
    
    override func loadView() {
        view = userMessageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil {
                //not signed in
                print("user not signed in")
                self.currentUser = nil
                self.userMessageView.messageLabel.text = "Please sign in to view your inbox"
                
                self.messageList.removeAll()
                self.userMessageView.tableViewMessages.reloadData()
                self.setupRightBarButton(isLoggedIn: false)
            }
            else {
                //signed in
                print("user signed in")
                self.currentUser = user
                self.userMessageView.messageLabel.text = "Welcome \(user?.displayName ?? "Anonymous")!"
                self.userMessageView.newMessageFloatingButton.isEnabled = true
                self.userMessageView.newMessageFloatingButton.isHidden = false
                self.setupRightBarButton(isLoggedIn: true)
                
                //loadContacts
//                self.database.collection("users").document((self.currentUser?.email)!).collection("contacts").addSnapshotListener(includeMetadataChanges: false, listener: { querySnapshot, error in
//                    if let documents = querySnapshot?.documents {
//                        self.contactList.removeAll()
//                        for document in documents {
//                            do {
//                                let contact = try document.data(as: Contact.self)
//                                self.contactList.append(contact)
//                            }
//                            catch{
//                                print(error)
//                            }
//                        }
//                    }
//                    self.contactList.sort(by: {$0.name < $1.name})
//                    self.homePage.tableViewContacts.reloadData()
//                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.bringSubviewToFront(userMessageView.newMessageFloatingButton)
        
        userMessageView.tableViewMessages.delegate = self
        userMessageView.tableViewMessages.dataSource = self
        userMessageView.tableViewMessages.separatorStyle = .none
//        userMessageView.tableViewMessages.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        
        userMessageView.newMessageFloatingButton.addTarget(self, action: #selector(createNewMessage), for: .touchUpInside)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
//    @objc func addNewContact() {
//
//        let addContactController = AddContactViewController()
//        addContactController.currentUser = self.currentUser
//        navigationController?.pushViewController(addContactController, animated: true)
//    }
    
    @objc func createNewMessage() {
        print("user is creating a new message")
    }


}
