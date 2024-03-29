//
//  Location.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

enum LocationFields: String {
    case Latitude = "lat"
    case Longitude = "lon"
}

class Location: Mappable {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init(json: JSON) {
        latitude = json[LocationFields.Latitude.rawValue].double
        longitude = json[LocationFields.Longitude.rawValue].double
    }
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        latitude    <- map[LocationFields.Latitude.rawValue]
        longitude    <- map[LocationFields.Longitude.rawValue]
    }
}
