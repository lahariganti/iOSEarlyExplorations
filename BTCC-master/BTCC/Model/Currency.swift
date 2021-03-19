//
//  Currency.swift
//  BTCC
//
//  Created by Lahari Ganti on 4/23/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import SwiftyJSON

class Currency {
    var code: String = ""
    var conversionFactor: Double = 0.0

    static func parseCurrency(json: JSON) -> Currency {
        let currency = Currency()
        for (k, v) in json {
            currency.code = k
            currency.conversionFactor = v.doubleValue
        }
        return currency
    }
}
