//
//  NewMessageTableManager.swift
//  WA8_14
//
//  Created by Diya on 11/19/23.
//

import Foundation
import UIKit

//handling dropDownTable for list of contacts and tableView for chats
extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //returns count of items in lists
        
        if tableView == newMessageView.recipientDropDownTable {
            return userNames.count
        }
        else if tableView == newMessageView.chatTableView {
            print("ChatCount = \(chatList.count)")
            return chatList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell initialization
        
        if tableView == newMessageView.recipientDropDownTable {
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = userNames[indexPath.row]
            return cell
        }
        if tableView == newMessageView.chatTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChats, for: indexPath) as! ChatTableViewCell
            let chat = chatList[indexPath.row]
            
            //cell alignment based on logged-in user to differentiate between incoming and outgoing chats for each user
            let isCurrentUser = chat.fromUser == self.currentUser?.email
            cell.alignChats(with: chat, isCurrentUser: isCurrentUser)
            
            //setting timestamp and message to be displayed in each cell
            cell.timeLabel.text = chat.timestamp
            cell.messageTextLabel.text = chat.message
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == newMessageView.recipientDropDownTable {
            
            let selectedName = userNames[indexPath.row]
            newMessageView.recipientTextField.text = selectedName
            newMessageView.recipientDropDownTable.isHidden = true
            
            //selected contact handler
            didSelectName?(selectedName)
        }
    }
}
