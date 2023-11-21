//
//  File.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import Foundation

struct Chat: Codable {
    
//    var chatUUID: String
    var timestamp: String
    var message: String
    var toUser: String
    var fromUser: String
    
    init(timestamp: String, message: String, toUser: String, fromUser: String) {
//        self.chatUUID = chatUUID
        self.timestamp = timestamp
        self.message = message
        self.toUser = toUser
        self.fromUser = fromUser
    }
    
    var asDictionary: [String: Any] {
            return [
                "timestamp": self.timestamp,
                "message": self.message,
                "toUser": self.toUser,
                "fromUser": self.fromUser
            ]
        }
    
}
