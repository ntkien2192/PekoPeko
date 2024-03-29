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
    case V210 = "2.1.0"
}

enum Router: URLRequestConvertible {
    static let baseURLString = "https://api.hungrybear.vn/"
    static let baseUploadFile = "https://files.hungrybear.vn/"
    
//    static let baseURLString = "https://api.pekopeko.vn/"
//    static let baseUploadFile = "https://files.pekopeko.vn/"
    
    // Router
    case login([String: AnyObject])
    case loginSocial([String: AnyObject])
    
    case connectFacebook([String: AnyObject])
    
    case getBaseUserInfo()
    case verifyPhoneNumber([String: AnyObject])
    
    case uploadUserAvatar()
    case uploadUserFullname([String: AnyObject])
    case uploadUserPassword([String: AnyObject])
    
    case getAllcard([String: AnyObject])
    case getUserCard([String: AnyObject])
    case addCard(String)
    case getCardInfo(String)
    case getCardAddresss(String)
    case deleteCard(String)
    case redeemAward([String: AnyObject])
    case redeemPoint([String: AnyObject])
    case redeemVoucher(String, [String: AnyObject])
    
    case getShopInfo(String, [String: AnyObject])
    case getShopFullInfo(String)
    case getShopMenuItem(String)
    
    case follow([String: AnyObject])
    case unFollow([String: AnyObject])
    
    case getAllVoucher([String: AnyObject])
    
    case getAllDiscover([String: AnyObject])
    case getMyDeal([String: AnyObject])
    case likeDeal(String)
    case unlikeDeal(String)
    case saveDeal(String)
    case unsaveDeal(String)
    case getDealInfo(String)
    case redeemDeal(String, [String: AnyObject])
    
    case getPromoCodeData()
    
    case forgotPassword([String: AnyObject])
    case renewPassword([String: AnyObject])
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
            
        case .loginSocial:
            return .post
            
        case .connectFacebook:
            return .put
            
        case .getBaseUserInfo:
            return .get
            
        case .verifyPhoneNumber:
            return .post
            
        case .uploadUserAvatar:
            return .post
            
        case .uploadUserFullname:
            return .put
            
        case .uploadUserPassword:
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
            
        case .redeemVoucher:
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
            
        case .getAllVoucher:
            return .get
            
        case .getAllDiscover:
            return .get
            
        case .getMyDeal:
            return .get
            
        case .likeDeal:
            return .post
            
        case .unlikeDeal:
            return .delete
            
        case .saveDeal:
            return .post
            
        case .unsaveDeal:
            return .delete
            
        case .getDealInfo:
            return .get
            
        case .redeemDeal:
            return .post
            
        case .getPromoCodeData:
            return .get
            
        case .forgotPassword:
            return .post
            
        case .renewPassword:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/phone"
         
        case .loginSocial:
            return "auth/social"
          
        case .connectFacebook:
            return "user/connect/facebook"
            
        case .getBaseUserInfo:
            return "user/base-info"
            
        case .verifyPhoneNumber:
            return "auth/verify"
            
        case .uploadUserAvatar:
            return "user/avatar"
            
        case .uploadUserFullname:
            return "user/basic"
            
        case .uploadUserPassword:
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
            
        case .redeemVoucher(let voucherID, _):
            return "voucher/\(voucherID)"
            
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
            
        case .getAllVoucher:
            return "voucher"
            
        case .getAllDiscover:
            return "discover"
            
        case .getMyDeal:
            return "user/deal"
            
        case .likeDeal(let dealID):
            return "deal/\(dealID)/like"
            
        case .unlikeDeal(let dealID):
            return "deal/\(dealID)/like"
            
        case .saveDeal(let dealID):
            return "deal/\(dealID)/save"
            
        case .unsaveDeal(let dealID):
            return "deal/\(dealID)/save"
            
        case .getDealInfo(let dealID):
            return "deal/\(dealID)"
           
        case .redeemDeal(let dealID, _):
            return "deal/\(dealID)/use"
            
        case .getPromoCodeData:
            return "user/base-panel"
            
        case .forgotPassword:
            return "auth/forgot-password"
            
        case .renewPassword:
            return "auth/set-password"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .login:
            return ApiVersion.V200.rawValue
            
        case .loginSocial:
            return ApiVersion.V200.rawValue
            
        case .connectFacebook:
            return ApiVersion.V200.rawValue
            
        case .getBaseUserInfo:
            return ApiVersion.V100.rawValue
            
        case .verifyPhoneNumber:
            return ApiVersion.V200.rawValue
            
        case .uploadUserAvatar:
            return ApiVersion.V100.rawValue
            
        case .uploadUserFullname:
            return ApiVersion.V200.rawValue
            
        case .uploadUserPassword:
            return ApiVersion.V210.rawValue
            
        case .getAllcard:
            return ApiVersion.V200.rawValue
            
        case .getUserCard:
            return ApiVersion.V200.rawValue
            
        case .addCard:
            return ApiVersion.V200.rawValue
        
        case .getCardInfo:
            return ApiVersion.V210.rawValue

        case .getCardAddresss:
            return ApiVersion.V100.rawValue
        
        case .deleteCard:
            return ApiVersion.V100.rawValue
            
        case .redeemAward:
            return ApiVersion.V200.rawValue
        
        case .redeemPoint:
            return ApiVersion.V200.rawValue
            
        case .redeemVoucher:
            return ApiVersion.V210.rawValue
        
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
            
        case .getAllVoucher:
            return ApiVersion.V210.rawValue
            
        case .getAllDiscover:
            return ApiVersion.V210.rawValue
            
        case .getMyDeal:
            return ApiVersion.V210.rawValue
            
        case .likeDeal:
            return ApiVersion.V210.rawValue
            
        case .unlikeDeal:
            return ApiVersion.V210.rawValue
            
        case .saveDeal:
            return ApiVersion.V210.rawValue
            
        case .unsaveDeal:
            return ApiVersion.V210.rawValue
            
        case .getDealInfo:
            return ApiVersion.V210.rawValue
            
        case .redeemDeal:
            return ApiVersion.V210.rawValue
            
        case .getPromoCodeData:
            return ApiVersion.V210.rawValue
            
        case .forgotPassword:
            return ApiVersion.V210.rawValue
            
        case .renewPassword:
            return ApiVersion.V210.rawValue
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

        case .loginSocial(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .connectFacebook(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .verifyPhoneNumber(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .uploadUserFullname(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .uploadUserPassword(let parameters):
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
            
        case .getAllVoucher(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
        case .getAllDiscover(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)

        case .getMyDeal(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        case .redeemDeal(_, let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .redeemVoucher(_, let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        case .forgotPassword(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)

        case .renewPassword(let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            break
        }

        return urlRequest
    }
}
