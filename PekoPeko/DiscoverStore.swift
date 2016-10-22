//
//  DiscoverStore.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class DiscoverStore {
//    class func getShopInfo(shopID: String, addressID: String, completionHandler: @escaping (Shop?, Error?) -> Void) {
//        
//        let parameters = ["address_id": addressID as AnyObject]
//        
//        _ = Alamofire.request(Router.getShopInfo(shopID, parameters)).responseGetShop({ (response) in
//            if let error = response.result.error {
//                completionHandler(nil, error)
//                return
//            }
//            guard response.result.value != nil else {
//                // TODO: Create error here
//                completionHandler(nil, nil)
//                return
//            }
//            completionHandler(response.result.value ?? nil, nil)
//        })
//    }
}
extension Alamofire.DataRequest {
//    func responseGetShop(_ completionHandler: @escaping (DataResponse<Shop?>) -> Void) -> Self {
//        let responseSerializer = DataResponseSerializer<Shop?> { request, response, data, error in
//            guard error == nil else {
//                return .failure(error!)
//            }
//            
//            guard let responseData = data else {
//                let error = ServerResponseError(data: nil, kind: .dataSerializationFailed)
//                return .failure(error)
//            }
//            
//            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
//            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
//            
//            guard response?.statusCode == 200 else {
//                switch result {
//                case .success(let value):
//                    let json = SwiftyJSON.JSON(value)
//                    let failureReason = json["message"].stringValue
//                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
//                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
//                    
//                    return .failure(error)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
//            
//            switch result {
//            case .success(let value):
//                let jsonObject = SwiftyJSON.JSON(value)
//                if jsonObject["code"].intValue != 1 {
//                    if  jsonObject["code"].intValue != -4 {
//                        
//                        if jsonObject["code"].intValue == -11 {
//                            AuthenticationStore().saveLoginValue(false)
//                        }
//                        
//                        let failureReason = jsonObject["message"].stringValue
//                        let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
//                        let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
//                        return .failure(error)
//                    } else {
//                        return .success(nil)
//                    }
//                } else {
//                    let json = jsonObject["data"]
//                    let shop = Shop(json: json)
//                    return .success(shop)
//                }
//                
//            case .failure(let error):
//                return .failure(error)
//            }
//        }
//        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
//    }
}
