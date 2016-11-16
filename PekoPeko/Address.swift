//
//  Address.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum AddressFields: String {
    case AddressID = "_id"
    case Address = "address"
    case Thumb = "thumb"
    case Location = "location"
    case QRData = "qr_data"
}

class Address: NSObject {
    var addressID: String?
    var addressContent: String?
    var thumb: String?
    var location: Location?
    var qrCode: QRCodeContent?
    
    required init(json: JSON) {
        addressID = json[AddressFields.AddressID.rawValue].string
        addressContent = json[AddressFields.Address.rawValue].string
        thumb = json[AddressFields.Thumb.rawValue].string
        location = Location(json: json[AddressFields.Location.rawValue])
        addressID = json[AddressFields.AddressID.rawValue].string
        if let data = json[AddressFields.QRData.rawValue].stringValue.data(using: String.Encoding.utf8) {
            let json = JSON(data: data)
            qrCode = QRCodeContent(json: json)
        }
    }
}
