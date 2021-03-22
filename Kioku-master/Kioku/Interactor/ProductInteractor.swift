//
//  ProductInteractor.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

class ProductInteractor {
	func fetchProducts(from endpoint: Endpoint, completionHandler: @escaping ((Product?, Error?) -> Void)) {
		guard let url = endpoint.url else { return }

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print(error)
				completionHandler(nil, error)
			}

			if let jsonData = data {
				guard let product = try? JSONDecoder().decode(Product.self, from: jsonData) else { return }
				completionHandler(product, nil)
			}
		}

		task.resume()
	}
}
