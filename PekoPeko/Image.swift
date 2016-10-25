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
}

class Image: NSObject {
    var extant: Int?
    var urls: [String]?
    
    required init(json: JSON) {
        extant = json[ImageFields.Extant.rawValue].int
        urls = json[ImageFields.Urls.rawValue].arrayValue.map({ $0.stringValue })
    }
}
