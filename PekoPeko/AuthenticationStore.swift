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
    
    fileprivate let accessTokenKey = "gomabu.accesstoken"
    fileprivate let authRestaurantIDKey = "gomabu.restaurantid"
    fileprivate let authAdminIDKey = "gomabu.adminid"
    
    fileprivate var defaults: UserDefaults = {
        
        return UserDefaults.standard
    }()
    
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
    
    // Authenticated restaurant id
    
    var hasAuthRestaurantIDToken: Bool {
        
        if authRestaurantID != nil {
            return true
        }
        
        return false
    }
    
    var authRestaurantID: String? {
        
        return defaults.value(forKey: authRestaurantIDKey) as? String ?? nil
    }
    
    var restaurantID: UInt64? {
        get {
            if let authRestaurantID = authRestaurantID {
                if let rid = UInt64(authRestaurantID) {
                    return rid
                }
                return nil
            }
            return nil
        }
    }
    
    func saveAuthRestaurantID(_ authRestaurantID: String) {
        
        defaults.set(authRestaurantID, forKey: authRestaurantIDKey)
        defaults.synchronize()
    }
    
    func deleteAuthRestauraID() {
        
        defaults.removeObject(forKey: authRestaurantIDKey)
        defaults.synchronize()
    }
    
    // Admin ID
    
    var hasAdminID: Bool {
        
        if adminID != nil {
            return true
        }
        
        return false
    }
    
    var authAdminID: String? {
        
        return defaults.value(forKey: authAdminIDKey) as? String ?? nil
    }
    
    var adminID: UInt64? {
        get {
            if let authAdminID = authAdminID {
                if let aid = UInt64(authAdminID) {
                    return aid
                }
                return nil
            }
            return nil
        }
    }
    
    func saveAuthAdminID(_ authAdminID: String) {
        
        defaults.set(authAdminID, forKey: authAdminIDKey)
        defaults.synchronize()
        
    }
    
    func deleteAuthAdminID() {
        
        defaults.removeObject(forKey: authAdminIDKey)
        defaults.synchronize()
    }
    
    // Clear all data
    func clear() {
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: authAdminIDKey)
        defaults.removeObject(forKey: authRestaurantIDKey)
        defaults.synchronize()
    }
    
    /// Get access token by username and password combine
    class func login(_ authParameters: AuthParameters, completionHandler: @escaping (Bool, Error?) -> Void) {
        let parameters = authParameters.toJSON()
        
        _ = Alamofire.request(Router.login(parameters as [String : AnyObject]))
            .responseGMBAccessToken { response in
                if let error = response.result.error {
                    completionHandler(false, error)
                    return
                }
                guard let responseData = response.result.value else {
                    // TODO: Create error here
                    completionHandler(false, nil)
                    return
                }
                // TODO: Create Auth struct
                if responseData.2 { // User is verified
                    AuthenticationStore().saveAcessToken(responseData.0)
                    AuthenticationStore().saveAuthAdminID(responseData.1)
                    
                    completionHandler(true, nil)
                } else {
                    let errorData = ["gomabu_id": responseData.1]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .unverifiedAccount)
                    completionHandler(false, error)
                }
        }
    }
    
    /**
     Exchange Facebook/Google access token with GMB access token
     
     - parameter parameters: Dictionary contains provider and access token. Example: ["provider": "facebook/google", "access_token": "token_string"]
     - parameter completionHandler:  The code to be executed once the request has finished.
     
     */
    class func exchangeToken(_ parameters: [String: String], completionHandler: @escaping (Bool, Error?) -> Void) {
        _ = Alamofire.request(Router.tokenExchange(parameters))
            .responseGMBAccessToken { response in
                if let error = response.result.error {
                    completionHandler(false, error)
                    return
                }
                
                guard let responseData = response.result.value else {
                    // TODO: Create error here
                    completionHandler(false, nil)
                    return
                }
                
                // TODO: Create Auth struct
                if responseData.2 { // User is verified
                    AuthenticationStore().saveAcessToken(responseData.0)
                    AuthenticationStore().saveAuthAdminID(responseData.1)
                    
                    completionHandler(true, nil)
                } else {
                    let errorData = ["gomabu_id": responseData.1]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .unverifiedAccount)
                    completionHandler(false, error)
                }
        }
    }
    
//    class func forgotPassword(_ parameters: [String: String], completionHandler: @escaping (Bool, Error?) -> Void) {
//        _ = Alamofire.request(Router.forgotPassword(parameters as [String : AnyObject]))
//            .responseStatus { response in
//                if let error = response.result.error {
//                    completionHandler(false, error)
//                    return
//                }
//                
//                completionHandler(response.result.value ?? false, nil)
//        }
//    }
//    
//    
//    class func resendActivationEmail(_ userID: String, completionHandler: @escaping (Bool, Error?) -> Void) {
//        _ = Alamofire.request(Router.resendActivationEmail(userID))
//            .responseStatus { response in
//                if let error = response.result.error {
//                    completionHandler(false, error)
//                    return
//                }
//                
//                completionHandler(response.result.value ?? false, nil)
//        }
//    }
}

enum SocialNetwork: String {
    case Facebook = "facebook"
    case Google = "google"
}

extension Alamofire.DataRequest {
    
    /// Handle response from Auth API -> return GMB access token
    func responseGMBAccessToken(_ completionHandler: @escaping (DataResponse<(String, String, Bool)>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<(String, String, Bool)> { request, response, data, error in
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
                let gmbToken = jsonObject["gmb_access_token"].stringValue
                let gmbID = jsonObject["authenticated_id"].stringValue
                let verified = jsonObject["verified"].boolValue
                
                return .success((gmbToken, gmbID, verified))
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func responseStatus(_ completionHandler: @escaping (DataResponse<Bool>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Bool> { request, response, data, error in
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
                let status = jsonObject["status"].stringValue
                
                return .success(status == "success")
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer,completionHandler: completionHandler)
    }
}
