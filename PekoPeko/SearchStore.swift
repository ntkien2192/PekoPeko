//
//  SearchStore.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class SearchStore {
    class func search(searchReqquest: SearchRequest, completionHandler: @escaping (SearchResponse?, Error?) -> Void) {
        
         let parameters = searchReqquest.toJSON()
        
        _ = Alamofire.request(SearchRouter.search(parameters as [String : AnyObject])).responseSearch({ (response) in
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
    
    func responseSearch(_ completionHandler: @escaping (DataResponse<SearchResponse?>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<SearchResponse?> { request, response, data, error in
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
                    let cardResponse = SearchResponse(json: jsonObject)
                    return .success(cardResponse)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
