//
//  Pagination.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 22/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PaginationFields: String {
    case NextPage = "next"
}

class Pagination: NSObject {
    var nextPage: String?
    
    required init(json: JSON) {
        nextPage = json[PaginationFields.NextPage.rawValue].string
    }
}
