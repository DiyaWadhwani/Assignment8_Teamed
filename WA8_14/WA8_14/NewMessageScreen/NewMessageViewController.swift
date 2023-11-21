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
        
        
        newMessageView.recipientDropDownTable.delegate = self
        newMessageView.recipientDropDownTable.dataSource = self
        
        newMessageView.pickerView.delegate = self
        newMessageView.pickerView.dataSource = self
        
        newMessageView.recipientTextField.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        newMessageView.sendButton.addTarget(self, action: #selector(sendMessageToContact), for: .touchUpInside)
        
        newMessageView.chatTableView.delegate = self
        newMessageView.chatTableView.dataSource = self
        newMessageView.chatTableView.isHidden = false
        
        setupTapGestureRecognizer()
        fetchUsersFromFirebase()
    }
    
    @objc func sendMessageToContact() {
        print("send button tapped")
        if let uwMessage = newMessageView.messageTextField.text{
            if !uwMessage.isEmpty{
                if let uwContact = newMessageView.recipientTextField.text {
                    if !uwContact.isEmpty {
                        sendChatToUser(uwContact, uwMessage)
                        //load table view and clear the message text field
                        //loadChatsOnUserViewScreen(chatUUID)
                    }
                }
            }
        }
    }
    
    func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // Hide the UIPickerView by resigning the first responder status
        newMessageView.recipientTextField.resignFirstResponder()
        newMessageView.messageTextField.becomeFirstResponder()
    }
    
    @objc func showDropDown() {
        newMessageView.recipientDropDownTable.isHidden = !newMessageView.recipientDropDownTable.isHidden
    }
}

extension NewMessageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedName = userNames[row]
        newMessageView.recipientTextField.text = selectedName
        didSelectName?(selectedName)
    }
    
}
