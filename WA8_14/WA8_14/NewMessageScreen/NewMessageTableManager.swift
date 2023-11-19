//
//  NewMessageTableManager.swift
//  WA8_14
//
//  Created by Diya on 11/19/23.
//

import Foundation
import UIKit

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == newMessageView.recipientDropDownTable {
            return userNames.count
        }
        else if tableView == newMessageView.chatTableView {
            print("MessageListCount = \(messageList.count)")
            return messageList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("YOOOOOOO")
        if tableView == newMessageView.recipientDropDownTable {
            print("trying to load table")
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = userNames[indexPath.row]
            return cell
        }
         if tableView == newMessageView.chatTableView {
            print("trying to load table")
            let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewChats, for: indexPath) as! ChatTableViewCell
            let message = messageList[indexPath.row]
            cell.timeLabel.text = message.timeStamp
            cell.messageTextLabel.text = message.messageText
            return cell
        }
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == newMessageView.recipientDropDownTable {
            let selectedName = userNames[indexPath.row]
            newMessageView.recipientTextField.text = selectedName
            newMessageView.recipientDropDownTable.isHidden = true
            
            // Callback for handling the selected option
            didSelectName?(selectedName)
        }
        if tableView == newMessageView.chatTableView {
            let selectedMessage = messageList[indexPath.row]
        }
    }
    
}
