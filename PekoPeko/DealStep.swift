//
//  DealStep.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DealStepFields: String {
    case PriceNew = "price_new"
    case SaveRequire = "save_require"
    
}

class DealStep: NSObject {
    var priceNew: Float?
    var saveRequire: Int?
    
    override init() {}
    
    required init(json: JSON) {
        priceNew = json[DealStepFields.PriceNew.rawValue].float
        saveRequire = json[DealStepFields.SaveRequire.rawValue].int
    }
}
