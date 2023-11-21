//
//  User.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import Foundation

//data model for userCollection
struct User: Codable {
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
