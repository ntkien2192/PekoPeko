
//
//  UserStore.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 11/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class UserStore {
    class func updateAvatar(_ image: UIImage, completionHandler: @escaping (String?, Error?) -> Void) {
        let imageData: Data = UIImageJPEGRepresentation(image, 0.9)!
        _ = Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
            }, with: Router.uploadUserAvatar(), encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    _ = upload.responseUploadImage({ (response) in
                        if let error = response.result.error {
                            completionHandler(nil, error)
                            return
                        }
                        guard let responseData = response.result.value else {
                            // TODO: Create error here
                            completionHandler(nil, nil)
                            return
                        }
                        completionHandler(responseData ?? "", nil)
                    })
                case .failure(_):
                    break
                }
        })
    }
    
    class func uploadFullName(_ user: User, completionHandler: @escaping (Bool, Error?) -> Void) {
        let parameters = user.toJSON()
        _ = Alamofire.request(Router.uploadUserFullname(parameters as [String : AnyObject])).responseUploadInfo({ (response) in
            if let error = response.result.error {
                completionHandler(false, error)
                return
            }
            guard response.result.value != nil else {
                // TODO: Create error here
                completionHandler(false, nil)
                return
            }
            completionHandler(true, nil)
        })
    }
    
}
extension Alamofire.DataRequest {
    
    func responseUploadInfo(_ completionHandler: @escaping (DataResponse<Bool?>) -> Void) -> Self {
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
                if jsonObject["code"].intValue != 10001 {
                    let failureReason = jsonObject["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    return .failure(error)
                } else  {
                    return .success(true)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    func responseUploadImage(_ completionHandler: @escaping (DataResponse<String?>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<String?> { request, response, data, error in
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
                if jsonObject["code"].intValue != 10001 {
                    let failureReason = jsonObject["message"].stringValue
                    let errorData = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = ServerResponseError(data: errorData as [String : AnyObject], kind: .dataSerializationFailed)
                    return .failure(error)
                } else  {
                    let data = jsonObject["data"]
                    let imageUrl = data["link"].string
                    return .success(imageUrl)
                }
                
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
