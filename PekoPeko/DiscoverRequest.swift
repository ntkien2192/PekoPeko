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
    case PreIDList = "pre_id"
    case LastTime = "last_time"
}

class DiscoverRequest: Mappable {
    var preID: [String]?
    var lastTime: Double?
    var preIDList: String?
    
    init() {}
    
    required init(preID: [String]?, lastTime: Double?) {
        self.preID = preID
        self.lastTime = lastTime
        if let preID = preID {
            self.preIDList = preID.joined(separator: ",")
        }
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        preIDList <- map[DiscoverRequestFields.PreIDList.rawValue]
        lastTime <- map[DiscoverRequestFields.LastTime.rawValue]
    }
}
