//
//  UserResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 03/12/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserResponseFields: String {
    case Users  = "data"
    case Pagination = "pagination"
}

class UserResponse: NSObject {
    var users: [User]?
    var pagination: Pagination?
    
    override init() {}
    
    required init(json: JSON) {
        users = json[UserResponseFields.Users.rawValue].arrayValue.map({ User(json: $0) })
        pagination = Pagination(json: json[UserResponseFields.Pagination.rawValue])
    }
}
