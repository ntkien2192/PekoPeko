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
    static let baseURLString = "https://api.hungrybear.vn/"
    static let baseUploadFile = "https://files.hungrybear.vn/"
    
    // Router
    case exchangeToken()
    case login([String: AnyObject])
    case verifyPhoneNumber([String: AnyObject])
    
    case uploadUserAvatar()
    case uploadUserFullname([String: AnyObject])
    
    case getAllcard([String: AnyObject])
    case getUserCard([String: AnyObject])
    case addCard(String)
    case getCard(String)
    
    var method: HTTPMethod {
        switch self {
        case .exchangeToken:
            return .get
            
        case .login:
            return .post
            
        case .verifyPhoneNumber:
            return .post
            
        case .uploadUserAvatar:
            return .post
            
        case .uploadUserFullname:
            return .put
            
        case .getAllcard:
            return .get
            
        case .getUserCard:
            return .get
            
        case .addCard:
            return .post
            
        case .getCard:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .exchangeToken:
            return "auth/refresh-token"
            
        case .login:
            return "auth/phone"
            
        case .verifyPhoneNumber:
            return "auth/verify"
            
        case .uploadUserAvatar:
            return "user/avatar"
            
        case .uploadUserFullname:
            return "user/basic"
            
        case .getAllcard:
            return "card/all"
            
        case .getUserCard:
            return "user/card"
            
        case .addCard(let cardID):
            return "card/\(cardID)"
            
        case .getCard(let cardID):
            return "card/\(cardID)"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .exchangeToken:
            return ApiVersion.V100.rawValue
            
        case .login:
            return ApiVersion.V200.rawValue
            
        case .verifyPhoneNumber:
            return ApiVersion.V200.rawValue
            
        case .uploadUserAvatar:
            return ApiVersion.V100.rawValue
            
        case .uploadUserFullname:
            return ApiVersion.V200.rawValue
            
        case .getAllcard:
            return ApiVersion.V200.rawValue
            
        case .getUserCard:
            return ApiVersion.V200.rawValue
            
        case .addCard:
            return ApiVersion.V200.rawValue
        
        case .getCard:
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
        var url = try Router.baseURLString.asURL()
        
        switch self {
        case .uploadUserAvatar():
            url = try Router.baseUploadFile.asURL()
        default:
            break
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = AuthenticationStore().accessToken {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .uploadUserAvatar():
            urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            break
        default:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest.setValue(apiVersion, forHTTPHeaderField: "Api-version")
        urlRequest.setValue(appVersion, forHTTPHeaderField: "App-version")
        urlRequest.setValue("\(UIDevice().modelName)/\(UIDevice().osVersion)", forHTTPHeaderField: "User-Agent")
        


        switch self {
            
        case .login(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .verifyPhoneNumber(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .uploadUserFullname(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getAllcard(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .getUserCard(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            break
        }
        

        return urlRequest
    }
}
