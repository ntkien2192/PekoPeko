//
//  DealStep.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DealPayStepFields: String {
    case PriceNew = "price_new"
    case SaveRequire = "save_require"
    
}

class DealPayStep: NSObject {
    var priceNew: Float?
    var saveRequire: Int?
    
    override init() {}
    
    required init(json: JSON) {
        priceNew = json[DealPayStepFields.PriceNew.rawValue].float
        saveRequire = json[DealPayStepFields.SaveRequire.rawValue].int
    }
}
