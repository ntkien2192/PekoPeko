//
//  AuthenticationRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 28/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper


enum AuthenticationRequestFields: String {
    case username = "username"
    case password = "password"
    case fullName = "fullName"
    case email = "email"
}

struct AuthenticationRequest: Mappable {
    var username: String?
    var password: String?
    var fullName: String?
    var email: String?
    
    init(username: String, password: String, fullName: String, email: String) {
        self.username = username
        self.password = password
        self.fullName = fullName
        self.email = email
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        username <- map[AuthenticationRequestFields.username.rawValue]
        password <- map[AuthenticationRequestFields.password.rawValue]
        fullName <- map[AuthenticationRequestFields.fullName.rawValue]
        email <- map[AuthenticationRequestFields.email.rawValue]
    }
}
