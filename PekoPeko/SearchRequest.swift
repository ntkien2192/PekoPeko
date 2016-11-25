//
//  SearchRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum SearchRequestFields: String {
    case Key = "key"
}

class SearchRequest: Mappable {
    var key: String?
    
    required init(key: String) {
        self.key = key
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        key <- map[SearchRequestFields.Key.rawValue]
    }
}
