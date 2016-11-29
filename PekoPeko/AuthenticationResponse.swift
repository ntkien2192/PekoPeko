//
//  AuthenticationResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 29/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum AuthenticationResponseFields: String {
    case token  = "token"
    case user = "user"
}

class AuthenticationResponse: NSObject {
    var user: User?
    
    override init() {}
    
    required init(json: JSON) {
        
        let token = json[AuthenticationResponseFields.token.rawValue].stringValue
        AuthenticationStore().saveAcessToken((token.isEmpty ? "" : token))
        
        let userData = json[AuthenticationResponseFields.user.rawValue]
        
        if let userData = userData.rawString() {
            AuthenticationStore().saveUser(userData)
        }
        
        user = User(json: userData)
    }
}
