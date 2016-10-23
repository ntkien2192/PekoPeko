//
//  VoucherResponse.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import SwiftyJSON

enum VoucherResponseFields: String {
    case Vouchers  = "data"
    case Pagination = "pagination"
}

class VoucherResponse: NSObject {
    var vouchers: [Voucher]?
    var pagination: Pagination?
    
    override init() {}
    
    required init(json: JSON) {
        vouchers = json[VoucherResponseFields.Vouchers.rawValue].arrayValue.map({ Voucher(json: $0) })
        pagination = Pagination(json: json[VoucherResponseFields.Pagination.rawValue])
    }
}
