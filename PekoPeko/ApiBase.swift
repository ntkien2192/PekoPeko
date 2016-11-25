//
//  ApiVersion.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 25/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

enum ApiBase: String {
    case baseURLString = "https://api.hungrybear.vn/"
    case baseUploadFile = "https://files.hungrybear.vn/"
    
    //    case baseURLString = "https://api.pekopeko.vn/"
    //    case baseUploadFile = "https://files.pekopeko.vn/"
}

enum ApiVersion: String {
    case V110 = "1.1.0"
    case V100 = "1.0.0"
    case V200 = "2.0.0"
    case V210 = "2.1.0"
    case V220 = "2.2.0"
}
