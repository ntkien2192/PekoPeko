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
    case PreIDList = "pre_id"
    case LastTime = "last_time"
}

class VoucherRequest: Mappable {
    var preID: [String]?
    var lastTime: String?
    var preIDList: String?
    
    init() {}
    
    required init(preID: [String]?, lastTime: String?) {
        self.preID = preID
        self.lastTime = lastTime
        if let preID = preID {
            self.preIDList = preID.joined(separator: ",")
        }
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        preIDList <- map[VoucherRequestFields.PreIDList.rawValue]
        lastTime <- map[VoucherRequestFields.LastTime.rawValue]
    }
}
