//
//  NewMessageViewController.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewMessageViewController: UIViewController {
    
    let newMessageView = NewMessageView()
    var userList: [User] = []
    var userNames = [String]()
    var chatList = [Chat]()
    let database = Firestore.firestore()
    var didSelectName: ((String) -> Void)?
    var currentUser: FirebaseAuth.User?
    var lastDocumentSnapshot: DocumentSnapshot?
    
    override func loadView() {
        view = newMessageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate and datasource properties for table and pickerView of userList
        newMessageView.recipientDropDownTable.delegate = self
        newMessageView.recipientDropDownTable.dataSource = self
        newMessageView.pickerView.delegate = self
        newMessageView.pickerView.dataSource = self
        
        //button-click for selecting contact
        newMessageView.recipientTextField.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        //button-click for sending a chat
        newMessageView.sendButton.addTarget(self, action: #selector(sendMessageToContact), for: .touchUpInside)
        
        //delegate and datasource properties for chatScreenTable
        newMessageView.chatTableView.delegate = self
        newMessageView.chatTableView.dataSource = self
        
        newMessageView.chatTableView.separatorStyle = .none
        
        //delegate property for textView
        newMessageView.messageTextView.delegate = self
        
        //close the user table on tapping outside the screen
        setupTapGestureRecognizer()
        
        //list of contacts/users in userCollection
        fetchUsersFromFirebase()
    }
    
    @objc func sendMessageToContact() {
        print("send button tapped")
        
        if let uwMessage = newMessageView.messageTextView.text{
            if uwMessage != ""{
                if let uwContact = newMessageView.recipientTextField.text {
                    if !uwContact.isEmpty {
                        
                        sendChatToUser(uwContact, uwMessage)
                    }
                }
            }
            else {
                showErrorAlert(message: "Please enter some text")
            }
        }
    }
    
    func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func setupTapGestureRecognizer() {
        
        //tap on screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        //hide picker view
        newMessageView.recipientTextField.resignFirstResponder()
        newMessageView.messageTextView.becomeFirstResponder()
    }
    
    @objc func showDropDown() {
        newMessageView.recipientDropDownTable.isHidden = !newMessageView.recipientDropDownTable.isHidden
    }
}

extension NewMessageViewController: UITextViewDelegate {
    
    //placeholder visibility based on user input
    func textViewDidChange(_ textView: UITextView) {
        
        //checking for whitespaces since textView does not have .isEmpty property
        let isTextViewEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        newMessageView.messagePlaceholderLabel.isHidden = !isTextViewEmpty
    }
    
}
