//
//  ServerResponseError.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 08/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import Foundation

struct ServerResponseError: Error {
    enum ErrorKind {
        case unverifiedAccount
        case dataSerializationFailed
    }
    let data: [String: AnyObject]?
    let kind: ErrorKind
}

extension ServerResponseError: CustomStringConvertible {
    var description: String {
        
        
        if let failureReason = data?[NSLocalizedFailureReasonErrorKey] as? String {
            return failureReason
        }
        
        var errorMessage = "#ServerResponseError"
        
        switch kind {
        case .unverifiedAccount:
            errorMessage = ""
        case .dataSerializationFailed:
            errorMessage = "Array could not be serialized because input data was nil."
        }
        
        return errorMessage
    }
}
