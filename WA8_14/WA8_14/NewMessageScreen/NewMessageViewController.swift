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
    let database = Firestore.firestore()
    var didSelectName: ((String) -> Void)?
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = newMessageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newMessageView.recipientDropDownTable.delegate = self
        newMessageView.recipientDropDownTable.dataSource = self
        
        newMessageView.pickerView.delegate = self
        newMessageView.pickerView.dataSource = self
        
        newMessageView.recipientTextField.addTarget(self, action: #selector(showDropDown), for: .touchDown)
        newMessageView.sendButton.addTarget(self, action: #selector(sendMessageToContact), for: .touchUpInside)
        
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

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = userNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedName = userNames[indexPath.row]
        newMessageView.recipientTextField.text = selectedName
        newMessageView.recipientDropDownTable.isHidden = true
        
        // Callback for handling the selected option
        didSelectName?(selectedName)
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
