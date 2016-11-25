//
//  SearchResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SearchResponseFields: String {
    case Shops = "data"
}

class SearchResponse: NSObject {
    var shops: [Shop]
    
    required init(json: JSON) {
        shops = json[SearchResponseFields.Shops.rawValue].arrayValue.map({ Shop(json: $0) })
    }
}
