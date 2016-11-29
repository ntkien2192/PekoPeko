//
//  ErrorResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 29/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ErrorResponseFields: String {
    case errors = "errors"
    case message = "message"
    case messageCode = "message_code"
}

class ErrorResponse: NSObject {
    var errors: ErrorField?
    var message: String?
    var messageCode: String?
    
    override init() {}
    
    required init(json: JSON) {
        message = json[ErrorResponseFields.message.rawValue].string
        messageCode = json[ErrorResponseFields.messageCode.rawValue].string
        
        if let errorsData = json[ErrorResponseFields.errors.rawValue].dictionary {
            let keys = errorsData.keys
            let firstkey = keys.first ?? ""
            errors = ErrorField(fieldName: firstkey, json: errorsData[firstkey] ?? JSON(""))
        }
    }
    
    func errorMessage() -> String? {
        if let message = message {
            return message
        } else {
            if let errors = errors {
                return errors.message ?? ""
            }
        }
        return nil
    }
}
