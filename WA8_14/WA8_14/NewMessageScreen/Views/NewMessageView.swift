//
//  NewMessageView.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import UIKit

class NewMessageView: UIView {
    
//    var recipientPicker: UIPickerView!
    var recipientDropDownTextField: UITextField!
    var contentWrapper: UIScrollView!
    var chatTableView: UITableView!
    var senderBar: UIView!
    var messageTextField: UITextField!
    var sendButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
//        setupRecipientPickerView()
        setupRecipientDropDownTextField()
        setupContentWrapper()
        setupChatTableView()
        setupSenderBar()
        setupMessageTextField()
        setupSendButton()
        
        initConstraints()
    }
    
//    func setupRecipientPickerView() {
//        recipientPicker = UIPickerView()
//    }
    
    func setupRecipientDropDownTextField() {
        recipientDropDownTextField = UITextField()
        recipientDropDownTextField.placeholder = "To:"
        recipientDropDownTextField.borderStyle = .roundedRect
        recipientDropDownTextField.layer.borderWidth = 2
        recipientDropDownTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        recipientDropDownTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recipientDropDownTextField)
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupChatTableView() {
        chatTableView = UITableView()
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chats")
        
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(chatTableView)
    }
    
    func setupSenderBar() {
        senderBar = UIView()
        
        senderBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(senderBar)
    }
    
    func setupMessageTextField() {
        messageTextField = UITextField()
        messageTextField.placeholder = "Message"
        messageTextField.borderStyle = .roundedRect
        messageTextField.layer.borderWidth = 2
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        senderBar.addSubview(messageTextField)
    }
    
    func setupSendButton() {
        sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(systemName: "paperplane.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sendButton.setTitle("", for: .normal)
        sendButton.tintColor = .green
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.layer.cornerRadius = 16
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        senderBar.addSubview(sendButton)
    }
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            recipientDropDownTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -20),
            recipientDropDownTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recipientDropDownTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            contentWrapper.topAnchor.constraint(equalTo: recipientDropDownTextField.bottomAnchor, constant: 10),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            chatTableView.topAnchor.constraint(equalTo: contentWrapper.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor),
            
            senderBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            senderBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            senderBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            messageTextField.topAnchor.constraint(equalTo: senderBar.topAnchor, constant: 5),
            messageTextField.leadingAnchor.constraint(equalTo: senderBar.leadingAnchor),
            messageTextField.trailingAnchor.constraint(lessThanOrEqualTo: senderBar.trailingAnchor),
            
            sendButton.topAnchor.constraint(equalTo: senderBar.topAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 45),
            sendButton.widthAnchor.constraint(equalToConstant: 45),
            sendButton.leadingAnchor.constraint(lessThanOrEqualTo: messageTextField.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: senderBar.trailingAnchor),
            
            
            
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
