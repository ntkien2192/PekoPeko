//
//  WordTime.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WordTimeFields: String {
    case Open = "open"
    case Close = "close"
}

class WordTime: NSObject {
    var openTime: String?
    var closeTime: String?
    
    required init(json: JSON) {
        openTime = json[WordTimeFields.Open.rawValue].string
        closeTime = json[WordTimeFields.Close.rawValue].string
    }
}
