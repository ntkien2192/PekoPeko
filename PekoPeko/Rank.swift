//
//  Rank.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 27/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum RankFields: String {
    case Image = "image"
    case Name = "name"
    case Point = "point"
    case Level = "level"
}

class Rank: NSObject {
    var image: String?
    var name: String?
    var point: Int?
    var level: Int?
    
    required init(json: JSON) {
        image = json[RankFields.Image.rawValue].string
        name = json[RankFields.Name.rawValue].string
        point = json[RankFields.Point.rawValue].int
        level = json[RankFields.Level.rawValue].int
    }
}
