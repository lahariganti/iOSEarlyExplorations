//
//  ConversionInteractor.swift
//  BTCC
//
//  Created by Lahari Ganti on 4/23/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ConversionInteractor: NSObject {
    static let shared = ConversionInteractor()

    func fetchItems(selectedCurrency: String, completionHandler: @escaping ((Currency, Error?) -> Void)) {
        let apiURL = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=\(selectedCurrency)"
        let params: [String: Any] = ["limit" : 25, "sort": "DESC"]
        Alamofire.request(apiURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            if response.result.isSuccess {
                guard let value = response.result.value else { return completionHandler(Currency(), nil)}
                let converiosnJSON: JSON = JSON(value)
                completionHandler(Currency.parseCurrency(json: converiosnJSON), nil)
            } else {
                print("Connection Issues")
            }
        }
    }
}
