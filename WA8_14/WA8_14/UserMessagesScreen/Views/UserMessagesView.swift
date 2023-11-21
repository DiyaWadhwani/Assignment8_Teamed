//
//  UserMessagesView.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import UIKit

class UserMessagesView: UIView {
    
    var messageIcon: UIImageView!
    var messageLabel: UILabel!
    var newMessageFloatingButton: UIButton!
    var tableViewMessages: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupMessageIcon()
        setupMessageLabel()
        setupNewMessageFloatingButton()
        setupTableViewMessages()
        
        initConstraints()
    }
    
    func setupMessageIcon() {
        
        messageIcon = UIImageView()
        messageIcon.image = UIImage(systemName: "tray.circle")?.withRenderingMode(.alwaysOriginal)
        messageIcon.tintColor = .black
        messageIcon.contentMode = .scaleToFill
        messageIcon.clipsToBounds = true
        messageIcon.layer.masksToBounds = true
        
        messageIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageIcon)
    }
    
    func setupMessageLabel() {
        
        messageLabel = UILabel()
        messageLabel.text = "Your inbox"
        messageLabel.font = .boldSystemFont(ofSize: 14)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(messageLabel)
    }
    
    func setupNewMessageFloatingButton() {
        
        newMessageFloatingButton = UIButton(type: .system)
        newMessageFloatingButton.setTitle("", for: .normal)
        newMessageFloatingButton.setImage(UIImage(systemName: "plus.message.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
        newMessageFloatingButton.tintColor = .black
        newMessageFloatingButton.contentHorizontalAlignment = .fill
        newMessageFloatingButton.contentVerticalAlignment = .fill
        newMessageFloatingButton.imageView?.contentMode = .scaleAspectFit
        newMessageFloatingButton.layer.cornerRadius = 16
        newMessageFloatingButton.imageView?.layer.shadowOffset = .zero
        newMessageFloatingButton.imageView?.layer.shadowOpacity = 0.7
        newMessageFloatingButton.imageView?.layer.shadowRadius = 0.5
        newMessageFloatingButton.imageView?.clipsToBounds = true
        
        newMessageFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(newMessageFloatingButton)
    }
    
    func setupTableViewMessages() {
        
        tableViewMessages = UITableView()
        
        tableViewMessages.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewMessages)
    }
    
    func initConstraints() {
        
        //view constraints
        NSLayoutConstraint.activate([
            
            messageIcon.heightAnchor.constraint(equalToConstant: 32),
            messageIcon.widthAnchor.constraint(equalToConstant: 32),
            messageIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            messageIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            messageLabel.topAnchor.constraint(equalTo: messageIcon.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: messageIcon.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: messageIcon.trailingAnchor, constant: 10),
            
            tableViewMessages.topAnchor.constraint(equalTo: messageIcon.bottomAnchor, constant: 8),
            tableViewMessages.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewMessages.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewMessages.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            newMessageFloatingButton.widthAnchor.constraint(equalToConstant: 55),
            newMessageFloatingButton.heightAnchor.constraint(equalToConstant: 55),
            newMessageFloatingButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            newMessageFloatingButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
