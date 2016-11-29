//
//  ErrorField.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 29/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ErrorFieldFields: String {
    case message = "message"
    case messageCode = "message_code"
}

class ErrorField: NSObject {
    var name: String?
    var message: String?
    var messageCode: String?
    
    override init() {}
    
    required init(fieldName: String, json: JSON) {
        name = fieldName
        message = json[ErrorFieldFields.message.rawValue].string
        messageCode = json[ErrorFieldFields.messageCode.rawValue].string
    }
}
