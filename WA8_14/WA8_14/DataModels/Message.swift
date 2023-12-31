//
//  Message.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation

//data model to load list of messages for a user
struct Message: Codable {
    
    var senderName: String
    var messageText: String
    var chatUUID: String
    
    init(senderName: String, messageText: String, chatUUID: String) {
        self.senderName = senderName
        self.messageText = messageText
        self.chatUUID = chatUUID
    }
}
