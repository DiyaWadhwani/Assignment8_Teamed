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
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewMessagesID, for: indexPath) as! MessagesTableViewCell
        
        cell.senderNameLabel.text = messageList[indexPath.row].senderName
        cell.messageTextLabel.text = messageList[indexPath.row].messageText
        
        return cell
    }
    
}
