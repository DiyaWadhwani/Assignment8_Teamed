//
//  ChatTableViewCell.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var timeLabel: UILabel!
    var messageTextLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupTimeLabel()
        setupMessageTextLabel()
        
        initConstraints()
        
    }
    
    func setupWrapperCellView() {
        
        wrapperCellView = UITableViewCell()
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupMessageTextLabel() {
        
        messageTextLabel = UILabel()
        messageTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        messageTextLabel.numberOfLines = 0
        messageTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageTextLabel.setContentHuggingPriority(.required, for: .vertical)
        
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageTextLabel)
    }
    
    func setupTimeLabel() {
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(timeLabel)
    }
    
    
    func initConstraints() {
        
        //view constraints
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            timeLabel.heightAnchor.constraint(equalToConstant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: messageTextLabel.topAnchor, constant: -5),
            
            messageTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            messageTextLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            messageTextLabel.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            messageTextLabel.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            
            wrapperCellView.heightAnchor.constraint(greaterThanOrEqualTo: messageTextLabel.heightAnchor, constant: 8),
        ])
    }
    
    func alignChats(with chat: Chat, isCurrentUser: Bool) {
        
        //matching user chats to the logged in user
        if isCurrentUser {
            
            //align chats to right
            messageTextLabel.contentMode = .right
            timeLabel.contentMode = .right
            wrapperCellView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
            wrapperCellView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            
            //outgoing messages
            wrapperCellView.backgroundColor = .green
            
        } else {
            
            //align chats to left
            messageTextLabel.contentMode = .left
            timeLabel.contentMode = .left
            wrapperCellView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            wrapperCellView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
            
            //incoming messages
            wrapperCellView.backgroundColor = .cyan
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
