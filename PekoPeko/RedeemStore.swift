//
//  RedeemStore.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import ObjectMapper

class RedeemStore {
    class func redeem(redeemRequest: RedeemRequest, completionHandler: @escaping (Bool, Error?) -> Void) {
        let parameters = redeemRequest.toJSON()
        _ = Alamofire.request(Router.redeemAward(parameters as [String : AnyObject])).responseRedeemAward({ (response) in
            if let error = response.result.error {
                completionHandler(false, error)
                return
            }
            guard response.result.value != nil else {
                // TODO: Create error here
                completionHandler(false, nil)
                return
            }
            completionHandler(response.result.value ?? false, nil)
        })
    }
    
    class func redeemPoint(point: Point, completionHandler: @escaping (Point?, Error?) -> Void) {
        let parameters = point.toJSON()
        _ = Alamofire.request(Router.redeemPoint(parameters as [String : AnyObject])).responseRedeemPoint({ (response) in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            guard response.result.value != nil else {
                // TODO: Create error here
                completionHandler(nil, nil)
                return
            }
            completionHandler(response.result.value ?? nil, nil)
        })
    }
}
extension Alamofire.DataRequest {
    
    func responseRedeemAward(_ completionHandler: @escaping (DataResponse<Bool>) -> Void) -> Self {
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
                if jsonObject["code"].intValue != 1 {
                    if  jsonObject["code"].intValue != -4 {
                        
                        if jsonObject["code"].intValue == -11 {
                            AuthenticationStore().saveLoginValue(false)
                        }
                        
                        let failureReason = jsonObject["message"].stringValue
                        let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                        let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                        return .failure(error)
                    } else {
                        return .success(false)
                    }
                } else {
                    return .success(true)
                }
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func responseRedeemPoint(_ completionHandler: @escaping (DataResponse<Point?>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Point?> { request, response, data, error in
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
                    if  jsonObject["code"].intValue != -4 {
                        
                        if jsonObject["code"].intValue == -11 {
                            AuthenticationStore().saveLoginValue(false)
                        }
                        
                        let failureReason = jsonObject["message"].stringValue
                        let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                        let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                        return .failure(error)
                    } else {
                        
                        return .success(nil)
                    }
                } else {
                    let point = Point(json: jsonObject["data"])
                    return .success(point)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
