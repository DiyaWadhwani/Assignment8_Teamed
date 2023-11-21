//
//  MessagesTableViewManager.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of messages -- \(messageList.count)")
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessages, for: indexPath) as! MessagesTableViewCell
        
        //setting cell properties
        cell.senderNameLabel.text = messageList[indexPath.row].senderName
        cell.messageTextLabel.text = messageList[indexPath.row].messageText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newMessageController = NewMessageViewController()
        
        newMessageController.newMessageView.recipientTextField.text = messageList[indexPath.row].senderName
        newMessageController.newMessageView.recipientTextField.font = .boldSystemFont(ofSize: 20)
        
        newMessageController.currentUser = self.currentUser!
        
        //loading chats for selected message
        print("loading chat with uuid: \(messageList[indexPath.row].chatUUID)")
        newMessageController.loadChatsOnUserViewScreen(messageList[indexPath.row].chatUUID)
        navigationController?.pushViewController(newMessageController, animated: true)
    }
    
}
