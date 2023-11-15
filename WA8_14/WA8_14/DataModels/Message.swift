//
//  Message.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation

struct Message: Codable {
    
    var senderName: String
    var messageText: String
    
    init(senderName: String, messageText: String) {
        self.senderName = senderName
        self.messageText = messageText
    }
}
