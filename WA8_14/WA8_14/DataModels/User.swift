//
//  User.swift
//  WA8_14
//
//  Created by Diya on 11/15/23.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String
    var password: String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
