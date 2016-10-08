//
//  Router.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://demo7551665.mockable.io/"
    
    // Router
    case tokenExchange([String: String])
    case login([String: AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .tokenExchange:
            return .post
        case .login:
            return .post
       
        }
    }
    
    var path: String {
        switch self {
        case .tokenExchange:
            return "/auth/token_exchange/"
            
        case .login:
            return "login"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = AuthenticationStore().accessToken {
            let plainAuthData = "\(token):".data(using: String.Encoding.utf8)
            // Use base64 auth string due to send bearer string not working
            let base64AuthString = (plainAuthData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))! as String
            urlRequest.setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .tokenExchange(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .login(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}
