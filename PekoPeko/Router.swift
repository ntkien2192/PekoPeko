//
//  Router.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import Alamofire

enum ApiVersion: String {
    case V110 = "1.1.0"
    case V100 = "1.0.0"
    case V200 = "2.0.0"
}

enum Router: URLRequestConvertible {
//    static let baseURLString = "https://api.hungrybear.vn/"
    static let baseURLString = "http://192.168.0.119:8000/"
    
    // Router
    case tokenExchange([String: String])
    case login([String: AnyObject])
    case verifyPhoneNumber([String: AnyObject])
    
    
    var method: HTTPMethod {
        switch self {
        case .tokenExchange:
            return .post
        case .login:
            return .post
        case .verifyPhoneNumber:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .tokenExchange:
            return "/auth/token_exchange/"
            
        case .login:
            return "auth/phone"
            
        case .verifyPhoneNumber:
            return "auth/verify"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .tokenExchange:
            return "/auth/token_exchange/"
            
        case .login:
            return ApiVersion.V200.rawValue
            
        case .verifyPhoneNumber:
            return ApiVersion.V200.rawValue
        }
    }
    
    var appVersion: String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return appVersion
        }
        return ""
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = AuthenticationStore().accessToken {
            let plainAuthData = "\(token):".data(using: String.Encoding.utf8)
            // Use base64 auth string due to send bearer string not working
            let base64AuthString = (plainAuthData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))! as String
            urlRequest.setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiVersion, forHTTPHeaderField: "Api-version")
        urlRequest.setValue(appVersion, forHTTPHeaderField: "App-version")
        urlRequest.setValue("\(UIDevice().modelName)/\(UIDevice().osVersion)", forHTTPHeaderField: "User-Agent")

        switch self {
        case .tokenExchange(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .login(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .verifyPhoneNumber(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}
