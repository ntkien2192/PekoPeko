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
//    static let baseURLString = "192.168.0.104:8000"
    
    static let baseUploadFile = "https://files.hungrybear.vn/"
    
    // Router
    case exchangeToken()
    case login([String: AnyObject])
    case getBaseUserInfo()
    case verifyPhoneNumber([String: AnyObject])
    
    case uploadUserAvatar()
    case uploadUserFullname([String: AnyObject])
    
    case getAllcard([String: AnyObject])
    case getUserCard([String: AnyObject])
    case addCard(String)
    case getCardInfo(String)
    case getCardAddresss(String)
    case deleteCard(String)
    case redeemAward([String: AnyObject])
    case redeemPoint([String: AnyObject])
    
    case getShopInfo(String, [String: AnyObject])
    case getShopFullInfo(String)
    case getShopMenuItem(String)
    
    case follow([String: AnyObject])
    case unFollow([String: AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .exchangeToken:
            return .get
            
        case .login:
            return .post
            
        case .getBaseUserInfo:
            return .get
            
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
            
        case .getCardInfo:
            return .get
            
        case .getCardAddresss:
            return .get
            
        case .deleteCard:
            return .delete
            
        case .redeemAward:
            return .post
            
        case .redeemPoint:
            return .post
            
        case .getShopInfo:
            return .get
            
        case .getShopFullInfo:
            return .get
            
        case .getShopMenuItem:
            return .get

        case .follow:
            return .put
            
        case .unFollow:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .exchangeToken:
            return "auth/refresh-token"
            
        case .login:
            return "auth/phone"
            
        case .getBaseUserInfo:
            return "user/base-info"
            
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
            
        case .getCardInfo(let cardID):
            return "card/\(cardID)"
            
        case .getCardAddresss(let cardID):
            return "shop/\(cardID)/address"
            
        case .deleteCard(let cardID):
            return "card/\(cardID)"
            
        case .redeemAward:
            return "card/redeem"
            
        case .redeemPoint:
            return "card/scan"
            
        case .getShopInfo(let shopID, _):
            return "shop/\(shopID)"
            
        case .getShopFullInfo(let shopID):
            return "shop/\(shopID)/full-info"
            
        case .getShopMenuItem(let shopID):
            return "shop/\(shopID)/menu"
            
        case .follow:
            return "user/follow"
            
        case .unFollow:
            return "user/unfollow"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .exchangeToken:
            return ApiVersion.V100.rawValue
            
        case .login:
            return ApiVersion.V200.rawValue
            
        case .getBaseUserInfo:
            return ApiVersion.V100.rawValue
            
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
        
        case .getCardInfo:
            return ApiVersion.V200.rawValue

        case .getCardAddresss:
            return ApiVersion.V100.rawValue
        
        case .deleteCard:
            return ApiVersion.V100.rawValue
            
        case .redeemAward:
            return ApiVersion.V200.rawValue
        
        case .redeemPoint:
            return ApiVersion.V200.rawValue
        
        case .getShopInfo:
            return ApiVersion.V200.rawValue
            
        case .getShopFullInfo:
            return ApiVersion.V100.rawValue
            
        case .getShopMenuItem:
            return ApiVersion.V100.rawValue

        case .follow:
            return ApiVersion.V100.rawValue
        
        case .unFollow:
            return ApiVersion.V100.rawValue
        }
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
        urlRequest.setValue(UIDevice().appVersion, forHTTPHeaderField: "App-version")
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
            
        case .redeemAward(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

        case .redeemPoint(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .getShopInfo(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .follow(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .unFollow(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            break
        }

        return urlRequest
    }
}
