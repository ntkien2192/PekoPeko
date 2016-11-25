//
//  PayResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 24/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PayResponseFields: String {
    case Price = "price"
    case Gateway = "gateway"
    case AtmMethod = "atm"
    case IntMethod = "international"
    case TransferMethod = "transfer"
}

class PayResponse: NSObject {
    var price: Float?
    var atmMethod: PayMethod?
    var intMethod: PayMethod?
    var transferMethod: PayMethod?
    
    required init(json: JSON) {
        let data = json["data"]
        
        price = data[PayResponseFields.Price.rawValue].float
        atmMethod = PayMethod(json: data[PayResponseFields.Gateway.rawValue][PayResponseFields.AtmMethod.rawValue])
        intMethod = PayMethod(json: data[PayResponseFields.Gateway.rawValue][PayResponseFields.IntMethod.rawValue])
        transferMethod = PayMethod(json: data[PayResponseFields.Gateway.rawValue][PayResponseFields.TransferMethod.rawValue])
    }
}
