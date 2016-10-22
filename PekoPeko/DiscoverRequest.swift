//
//  DiscoverRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum DiscoverRequestFields: String {
    case PreID = "pre_id"
    case LastTime = "last_time"
}

class DiscoverRequest: Mappable {
    var preID: String?
    var lastTime: String?
    
    required init(preID: String, lastTime: String) {
        self.preID = preID
        self.lastTime = lastTime
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        preID <- map[DiscoverRequestFields.PreID.rawValue]
        preID <- map[DiscoverRequestFields.LastTime.rawValue]
    }
}
