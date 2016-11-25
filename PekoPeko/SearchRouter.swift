//
//  SearchRouter.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

enum SearchRouter: URLRequestConvertible {
    
    case search([String: AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "shop/search"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .search:
            return ApiVersion.V100.rawValue
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try ApiBase.baseURLString.rawValue.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = AuthenticationStore().accessToken {
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiVersion, forHTTPHeaderField: "Api-version")
        urlRequest.setValue(UIDevice().appVersion, forHTTPHeaderField: "App-version")
        urlRequest.setValue("\(UIDevice().modelName)/\(UIDevice().osVersion)", forHTTPHeaderField: "User-Agent")
        
        switch self {
            
        case .search(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
