//
//  UserRouter.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 30/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    
    case getUserInfo()
    
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "api/v1/users/me"
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
        
//        switch self {
//            
//        case .register(let parameters):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
//            
//        case .login(let parameters):
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
//            
//        case .loginWithFacebook(let parameters):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        }
//        
        return urlRequest
    }
}
