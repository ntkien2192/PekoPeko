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
    fileprivate let isLoginKey = "pekopeko.isLoginKey"
    fileprivate let userKey = "pekopeko.userKey"
    fileprivate let userIDKey = "pekopeko.userIDKey"
    
    fileprivate var defaults: UserDefaults = {
        
        return UserDefaults.standard
    }()
    
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
    
    //MARK: User
    
    var user: User? {
        if let data = defaults.value(forKey: userKey) as? String {
            if let userData = data.data(using: String.Encoding.utf8) {
                return User(json: JSON(data: userData))
            }
        }
        return nil
    }
    
    func saveUser(_ user: String) {
        defaults.set(user, forKey: userKey)
        defaults.synchronize()
    }

    // Authenticated userID
    
    var userID: String {
        return defaults.value(forKey: userIDKey) as? String ?? ""
    }
    
    func saveUserID(_ userID: String) {
        defaults.set(userID, forKey: userIDKey)
        defaults.synchronize()
    }
    
    // Clear all data
    func clear() {
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: isLoginKey)
        defaults.removeObject(forKey: userKey)
        defaults.removeObject(forKey: userIDKey)
        defaults.synchronize()
    }
    
    
    
    
    
    //MARK: AuthenticationStore
    
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
    
    class func loginSocial(_ loginParameters: LoginParameter, completionHandler: @escaping (User?, Error?) -> Void) {
        let parameters = loginParameters.toJSON()
        
        _ = Alamofire.request(Router.loginSocial(parameters as [String : AnyObject])).responseLogin({ (response) in
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
    
    class func forgotPassword(loginParameters: LoginParameter, completionHandler: @escaping (Bool, Error?) -> Void) {
        let parameters = loginParameters.toJSON()
        
        _ = Alamofire.request(Router.forgotPassword(parameters as [String : AnyObject])).responseForgotPassword({ (response) in
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

    class func renewPassword(loginParameters: LoginParameter, completionHandler: @escaping (Bool, Error?) -> Void) {
        let parameters = loginParameters.toJSON()
        
        _ = Alamofire.request(Router.renewPassword(parameters as [String : AnyObject])).responseForgotPassword({ (response) in
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
    
    
    
    //MARK: AuthenticationStore
    
    class func register(authenticationRequest: AuthenticationRequest, completionHandler: @escaping (AuthenticationResponse?, Error?) -> Void) {
        
        let parameters = authenticationRequest.toJSON()
        
        _ = Alamofire.request(AuthenticationRouter.register(parameters as [String : AnyObject])).responseRegister({ (response) in
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
 
    class func login(authenticationRequest: AuthenticationRequest, completionHandler: @escaping (AuthenticationResponse?, Error?) -> Void) {
        
        let parameters = authenticationRequest.toJSON()
        
        _ = Alamofire.request(AuthenticationRouter.login(parameters as [String : AnyObject])).responseRegister({ (response) in
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
                    
                    if jsonObject["code"].intValue == -11 {
                        AuthenticationStore().saveLoginValue(false)
                    }
                    
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
                    
                    let userID = data["_id"].stringValue
                    if !userID.isEmpty {
                        AuthenticationStore().saveUserID(userID)
                    }
                    
                    return .success(user)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func responseForgotPassword(_ completionHandler: @escaping (DataResponse<Bool?>) -> Void) -> Self {
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
                    
                    if jsonObject["code"].intValue == -11 {
                        AuthenticationStore().saveLoginValue(false)
                    }
                    
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
    
    func responseRegister(_ completionHandler: @escaping (DataResponse<AuthenticationResponse?>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<AuthenticationResponse?> { request, response, data, error in
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
                    
                    let failureReason = ErrorResponse(json: json).errorMessage()
                    
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
                
                let response = AuthenticationResponse(json: jsonObject)
                
                return .success(response)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
