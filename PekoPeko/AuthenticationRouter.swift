//
//  AuthenticationRouter.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 28/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

enum AuthenticationRouter: URLRequestConvertible {
    
    case register([String: AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .register:
            return "sign_up"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiBase.baseString.rawValue.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = AuthenticationStore().accessToken {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
            
        case .register(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
