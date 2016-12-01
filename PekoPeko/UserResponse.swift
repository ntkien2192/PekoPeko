//
//  UserResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 30/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserResponseFields: String {
    case token  = "token"
    case user = "user"
}

class UserResponse: NSObject {
    
    override init() {}
    
    required init(json: JSON) {
        
        let token = json[AuthenticationResponseFields.token.rawValue].stringValue
        AuthenticationStore().saveAcessToken((token.isEmpty ? "" : token))
        
        let userData = json[AuthenticationResponseFields.user.rawValue]
        
        if let userData = userData.rawString() {
            AuthenticationStore().saveUser(userData)
        }
        
    }
}
