//
//  Authentication.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import ObjectMapper


struct AuthParameters: Mappable {
    var username: String?
    var password: String?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        username    <- map["username"]
        password    <- map["password"]
    }
}
