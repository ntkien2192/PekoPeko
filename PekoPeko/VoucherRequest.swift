//
//  VoucherRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum VoucherRequestFields: String {
    case PreID = "pre_id"
    case LastTime = "last_time"
}

class VoucherRequest: Mappable {
    var preID: [String]?
    var lastTime: String?
    
    init() {}
    
    required init(preID: [String], lastTime: String) {
        self.preID = preID
        self.lastTime = lastTime
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        preID <- map[VoucherRequestFields.PreID.rawValue]
        preID <- map[VoucherRequestFields.LastTime.rawValue]
    }
}
