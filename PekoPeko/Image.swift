//
//  Image.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ImageFields: String {
    case Extant = "extant"
    case Urls = "urls"
    
    case ImageID = "_id"
    case IsMain = "is_main"
    case ImageType = "type"
    case CreatedAt = "created_at"
    case Link = "link"
}

class Image: NSObject {
    var extant: Int?
    var urls: [String]?
    
    var imageID: String?
    var isMain: Bool?
    var imageType: Int?
    var createdAt: Double?
    var url: String?
    
    required init(json: JSON) {
        extant = json[ImageFields.Extant.rawValue].int
        urls = json[ImageFields.Urls.rawValue].arrayValue.map({ $0.stringValue })
        
        imageID = json[ImageFields.ImageID.rawValue].string
        isMain = json[ImageFields.IsMain.rawValue].bool
        imageType = json[ImageFields.ImageType.rawValue].int
        createdAt = json[ImageFields.CreatedAt.rawValue].double
        url = json[ImageFields.Link.rawValue].string
    }
}
