//
//  CardResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 11/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CardResponseFields: String {
    case Cards  = "data"
    case Pagination = "pagination"
}

class CardResponse: NSObject {
    var cards: [Card]?
    var pagination: Pagination?
    
    override init() {}
    
    required init(json: JSON) {
        cards = json[CardResponseFields.Cards.rawValue].arrayValue.map({ Card(json: $0) })
        pagination = Pagination(json: json[CardResponseFields.Pagination.rawValue])
    }
}
