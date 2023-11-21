//
//  NewMessageView.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import UIKit

class NewMessageView: UIView {
    
    var recipientTextField: UITextField!
    var pickerView: UIPickerView!
    var recipientDropDownTable: UITableView!
    var contentWrapper: UIScrollView!
    var chatTableView: UITableView!
    var senderBar: UIView!
    var messageTextView: UITextView!
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupRecipientTextField()
        setupRecipientDropDownTable()
        //        setupContentWrapper()
        setupChatTableView()
        setupSenderBar()
        setupMessageTextView()
        setupSendButton()
        
        initConstraints()
    }
    
    func setupRecipientTextField() {
        
        recipientTextField = UITextField()
        recipientTextField.placeholder = "Select a contact"
        recipientTextField.borderStyle = .roundedRect
        recipientTextField.layer.borderWidth = 2
        recipientTextField.layer.borderColor = UIColor.lightGray.cgColor
        recipientTextField.isUserInteractionEnabled = true
        
        pickerView = UIPickerView()
        recipientTextField.inputView = pickerView
        
        recipientTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recipientTextField)
    }
    
    func setupRecipientDropDownTable() {
        recipientDropDownTable = UITableView()
        recipientDropDownTable.isHidden = true
        recipientDropDownTable.layer.zPosition = 1
        
        recipientDropDownTable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recipientDropDownTable)
    }
    
    func setupChatTableView() {
        chatTableView = UITableView()
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: Configs.tableViewChats)
        
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chatTableView)
    }
    
    func setupSenderBar() {
        senderBar = UIView()
        
        senderBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(senderBar)
    }
    
    func setupMessageTextView() {
        messageTextView = UITextView()
        messageTextView.font = .systemFont(ofSize: 15)
        messageTextView.layer.borderWidth = 2
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        messageTextView.isUserInteractionEnabled = true
        messageTextView.isSelectable = true
        messageTextView.isEditable = true
        
        messageTextView.keyboardType = .default
        messageTextView.returnKeyType = .done
        messageTextView.autocapitalizationType = .sentences
        messageTextView.dataDetectorTypes = .all
        
        messageTextView.autocorrectionType = UITextAutocorrectionType.yes
        messageTextView.spellCheckingType = UITextSpellCheckingType.yes
        
        messageTextView.textContainer.lineBreakMode = .byWordWrapping
        messageTextView.textContainer.maximumNumberOfLines = 0
        
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        senderBar.addSubview(messageTextView)
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
        sendButton.isEnabled = true
        sendButton.isUserInteractionEnabled = true
        sendButton.isHidden = false
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        senderBar.addSubview(sendButton)
    }
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            recipientTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -20),
            recipientTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recipientTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            chatTableView.topAnchor.constraint(equalTo: recipientTextField.bottomAnchor, constant: 10),
            chatTableView.bottomAnchor.constraint(equalTo: senderBar.topAnchor, constant: -8),
            chatTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            chatTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            senderBar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            senderBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            senderBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            messageTextView.topAnchor.constraint(equalTo: senderBar.topAnchor, constant: 5),
            messageTextView.leadingAnchor.constraint(equalTo: senderBar.leadingAnchor, constant: 10),
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageTextView.bottomAnchor.constraint(equalTo: senderBar.bottomAnchor, constant: -5),
            
            sendButton.topAnchor.constraint(equalTo: senderBar.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: senderBar.trailingAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: senderBar.bottomAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 45),
            sendButton.widthAnchor.constraint(equalToConstant: 45),
            
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
