//
//  MessagesTableViewCell.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var senderNameLabel: UILabel!
    var messageTextLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupSenderNameLabel()
        setupMessageTextLabel()
        
        initConstraints()
    }
    
    func setupWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupSenderNameLabel() {
        senderNameLabel = UILabel()
        senderNameLabel.font = .boldSystemFont(ofSize: 20)
        
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(senderNameLabel)
    }
    
    func setupMessageTextLabel() {
        messageTextLabel = UILabel()
        messageTextLabel.font = .boldSystemFont(ofSize: 14)
        
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageTextLabel)
    }
    
    func initConstraints() {
        
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            senderNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            senderNameLabel.heightAnchor.constraint(equalToConstant: 20),
            senderNameLabel.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            messageTextLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 2),
            messageTextLabel.leadingAnchor.constraint(equalTo: senderNameLabel.leadingAnchor),
            messageTextLabel.heightAnchor.constraint(equalToConstant: 16),
            messageTextLabel.widthAnchor.constraint(lessThanOrEqualTo: senderNameLabel.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 75),
        
        ])
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
