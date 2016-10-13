//
//  CardRequest.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 12/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper

enum CardRequestFields: String {
    case Latitude = "lat"
    case Longitude = "lon"
    case NextPage = "from"
}

class CardRequest: Mappable {
    var latitude: Double?
    var longitude: Double?
    var nextPage: String?
    
    required init(location: Location?, nextPage: String?) {
        if let location = location {
            self.latitude = location.latitude
            self.longitude = location.longitude
        } else {
            self.latitude = 0.0
            self.longitude = 0.0
        }
        if let nextPage = nextPage {
            self.nextPage = nextPage
        } else {
            self.nextPage = "0"
        }
    }
    
    required init(nextPage: String?) {
        if let nextPage = nextPage {
            self.nextPage = nextPage
        } else {
            self.nextPage = "0"
        }
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        latitude <- map[CardRequestFields.Latitude.rawValue]
        longitude <- map[CardRequestFields.Longitude.rawValue]
        nextPage <- map[CardRequestFields.NextPage.rawValue]
    }
}
