//
//  DiscoverResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DiscoverResponseFields: String {
    case Discover  = "data"
    case Pagination = "pagination"
}

class DiscoverResponse: NSObject {
    var discovers: [Discover]?
    var pagination: Pagination?
    
    override init() {}
    
    required init(json: JSON) {
        discovers = json[DiscoverResponseFields.Discover.rawValue].arrayValue.map({ Discover(json: $0) })
        pagination = Pagination(json: json[DiscoverResponseFields.Pagination.rawValue])
    }
}
