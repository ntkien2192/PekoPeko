//
//  AuthenticationStore.swift
//  Gomabu For Restaurant
//
//  Created by Hieu Tran on 3/10/16.
//  Copyright © 2016 Gomabu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class AuthenticationStore {
    
    fileprivate let accessTokenKey = "pekopeko.accesstoken"
    fileprivate let userIDKey = "gomabu.userid"
    fileprivate let isLoginKey = "pekopeko.isLoginKey"
    fileprivate let phoneNumberKey = "pekopeko.phoneNumber"
    
    fileprivate var defaults: UserDefaults = {
        
        return UserDefaults.standard
    }()
    
    // MARK: User ID
    
    var hasUserID: Bool {
        if userID != nil {
            return true
        }
        
        return false
    }
    
    var userID: String? {
        return defaults.value(forKey: userIDKey) as? String ?? nil
    }
    
    func saveUserID(_ userID: String) {
        defaults.set(userID, forKey: userIDKey)
        defaults.synchronize()
        
    }
    
    func deleteUserID() {
        defaults.removeObject(forKey: userIDKey)
        defaults.synchronize()
    }

    
    //MARK: LOGIN
    
    
    var isLogin: Bool {
        return defaults.value(forKey: isLoginKey) as? Bool ?? false
    }
    
    func saveLoginValue(_ isLogin: Bool) {
        defaults.set(isLogin, forKey: isLoginKey)
        defaults.synchronize()
    }
    
    // Access token
    
    var hasAccessToken: Bool {
        if accessToken != nil {
            return true
        }
        return false
    }
    
    var accessToken: String? {
        return defaults.value(forKey: accessTokenKey) as? String ?? nil
    }
    
    func saveAcessToken(_ accessToken: String) {
        defaults.set(accessToken, forKey: accessTokenKey)
        defaults.synchronize()
    }
    
    func deleteAccessToken() {
        
        defaults.removeObject(forKey: accessTokenKey)
        defaults.synchronize()
    }
    
    // Authenticated phoneNumber
    
    var hasPhoneNumber: Bool {
        if phoneNumber != nil {
            return true
        }
        return false
    }
    
    var phoneNumber: String? {
        return defaults.value(forKey: phoneNumberKey) as? String ?? nil
    }
    
    func savePhoneNumber(_ phoneNumber: String) {
        defaults.set(phoneNumber, forKey: phoneNumberKey)
        defaults.synchronize()
    }
    
    func deletePhoneNumber() {
        defaults.removeObject(forKey: phoneNumberKey)
        defaults.synchronize()
    }
    
    // Clear all data
    func clear() {
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: phoneNumberKey)
        defaults.removeObject(forKey: isLoginKey)
        defaults.synchronize()
    }
    
    class func login(_ loginParameters: LoginParameter, completionHandler: @escaping (User?, Error?) -> Void) {
        let parameters = loginParameters.toJSON()
        _ = Alamofire.request(Router.login(parameters as [String : AnyObject])).responseLogin({ (response) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            guard let responseData = response.result.value else {
                // TODO: Create error here
                completionHandler(nil, nil)
                return
            }
            completionHandler(responseData, nil)
        })
    }
    
    class func confirm(_ loginParameters: LoginParameter, completionHandler: @escaping (User?, Error?) -> Void) {
        let parameters = loginParameters.toJSON()
        _ = Alamofire.request(Router.verifyPhoneNumber(parameters as [String : AnyObject])).responseLogin({ (response) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            guard let responseData = response.result.value else {
                // TODO: Create error here
                completionHandler(nil, nil)
                return
            }
            completionHandler(responseData, nil)
        })
    }
    
    class func exchangeToken(completionHandler: @escaping (Bool, Error?) -> Void) {
        _ = Alamofire.request(Router.exchangeToken()).responseExchangeToken({ (response) in
            if let error = response.result.error {
                completionHandler(false, error)
                return
            }
            guard let responseData = response.result.value else {
                // TODO: Create error here
                completionHandler(false, nil)
                return
            }
            completionHandler(responseData ?? false, nil)
        })
    }
}

enum SocialNetwork: String {
    case Facebook = "facebook"
    case Google = "google"
}

extension Alamofire.DataRequest {
    
    func responseLogin(_ completionHandler: @escaping (DataResponse<User>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<User> { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            guard let responseData = data else {
                let error = ServerResponseError(data: nil, kind: .dataSerializationFailed)
                return .failure(error)
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            guard response?.statusCode == 200 else {
                switch result {
                case .success(let value):
                    let json = SwiftyJSON.JSON(value)
                    let failureReason = json["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    
                    return .failure(error)
                case .failure(let error):
                    return .failure(error)
                }
            }
            
            switch result {
            case .success(let value):
                let jsonObject = SwiftyJSON.JSON(value)
                if jsonObject["code"].intValue != 1 {
                    let failureReason = jsonObject["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    return .failure(error)
                } else  {
                    let data = jsonObject["data"]
                    let user = User(json: data)
                    
                    let token = data["token"].stringValue
                    if !token.isEmpty {
                        AuthenticationStore().saveAcessToken(token)
                    }
                    
                    return .success(user)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func responseExchangeToken(_ completionHandler: @escaping (DataResponse<Bool?>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Bool?> { request, response, data, error in
            guard error == nil else {
                return .failure(error!)
            }
            
            guard let responseData = data else {
                let error = ServerResponseError(data: nil, kind: .dataSerializationFailed)
                return .failure(error)
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            guard response?.statusCode == 200 else {
                switch result {
                case .success(let value):
                    let json = SwiftyJSON.JSON(value)
                    let failureReason = json["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    
                    return .failure(error)
                case .failure(let error):
                    return .failure(error)
                }
            }
            
            switch result {
            case .success(let value):
                let jsonObject = SwiftyJSON.JSON(value)
                if jsonObject["code"].intValue != 1 {
                    let failureReason = jsonObject["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    return .failure(error)
                } else  {
                    let data = jsonObject["data"]
                    let token = data["token"].stringValue
                    if !token.isEmpty {
                        AuthenticationStore().saveAcessToken(token)
                    }
                    
                    return .success(true)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
