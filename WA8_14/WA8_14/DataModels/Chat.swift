//
//  File.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import Foundation

//data model for chatCollection
struct Chat: Codable {
    
    var timestamp: String
    var message: String
    var toUser: String
    var fromUser: String
    
    init(timestamp: String, message: String, toUser: String, fromUser: String) {
        
        self.timestamp = timestamp
        self.message = message
        self.toUser = toUser
        self.fromUser = fromUser
    }
    
    //converting chat object to dictionary to store data in firestore
    var asDictionary: [String: Any] {
            return [
                "timestamp": self.timestamp,
                "message": self.message,
                "toUser": self.toUser,
                "fromUser": self.fromUser
            ]
        }
    
}
