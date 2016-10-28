//
//  VipCard.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum VipCardFields: String {
    case HPRequire = "hp_require"
    case Image = "image"
    case Benefit = "benefit"
}

class VipCard: NSObject {
    var hpRequire: Int?
    var imageUrl: String?
    var benefit: String?
    var isCurrent: Bool = false
    var isLock: Bool = true
    var needPoint: Int?
    
    override init() {
        
    }
    
    required init(json: JSON) {
        hpRequire = json[VipCardFields.HPRequire.rawValue].int
        imageUrl = json[VipCardFields.Image.rawValue].string
        benefit = json[VipCardFields.Benefit.rawValue].string
    }
}
