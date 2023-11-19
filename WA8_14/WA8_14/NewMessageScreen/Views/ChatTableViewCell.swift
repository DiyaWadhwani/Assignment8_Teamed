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
        wrapperCellView.backgroundColor = UIColor(red: 0.80, green: 0.93, blue: 0.99, alpha: 1.00)
        wrapperCellView.layer.borderColor = UIColor.black.cgColor
        
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        timeLabel.contentMode = .left
        timeLabel.backgroundColor = .yellow
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(timeLabel)
    }
    
    func setupMessageTextLabel() {
        messageTextLabel = UILabel()
        messageTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageTextLabel.contentMode = .left
        messageTextLabel.backgroundColor = .green
        
        timeLabel.isHidden = false
        messageTextLabel.isHidden = false
        timeLabel.alpha = 1.0
        messageTextLabel.alpha = 1.0
        
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(messageTextLabel)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            
            
            timeLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            timeLabel.heightAnchor.constraint(equalToConstant: 10),
            timeLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            messageTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            messageTextLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            messageTextLabel.heightAnchor.constraint(equalToConstant: 20),
            messageTextLabel.widthAnchor.constraint(equalTo: wrapperCellView.widthAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 80),
            
        ])
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
