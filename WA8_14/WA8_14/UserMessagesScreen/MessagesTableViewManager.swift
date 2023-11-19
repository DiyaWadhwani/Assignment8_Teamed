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
        print("messageList count -- \(messageList.count)")
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessages, for: indexPath) as! MessagesTableViewCell
        
        cell.senderNameLabel.text = messageList[indexPath.row].senderName
        print("cell senderName -- \(cell.senderNameLabel.text)")
        cell.messageTextLabel.text = messageList[indexPath.row].messageText
        print("cell message -- \(cell.messageTextLabel.text)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newMessageController = NewMessageViewController()
        newMessageController.newMessageView.recipientTextField.text = messageList[indexPath.row].senderName
        newMessageController.currentUser = self.currentUser!
        navigationController?.pushViewController(newMessageController, animated: true)
    }
    
}
