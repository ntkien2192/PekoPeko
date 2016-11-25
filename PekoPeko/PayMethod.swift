//
//  PayMethod.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PayMethodFields: String {
    case Content = "content"
    case Url = "url"
}

class PayMethod: NSObject {
    var content: String?
    var payUrl: String?
    
    required init(json: JSON) {
        content = json[PayMethodFields.Content.rawValue].string
        payUrl = json[PayMethodFields.Url.rawValue].string
    }
}
