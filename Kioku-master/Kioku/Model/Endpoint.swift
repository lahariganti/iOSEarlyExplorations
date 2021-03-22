//
//  Endpoint.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

struct Endpoint {
	let path: String
	let queryItems: [URLQueryItem]
}

extension Endpoint {
	var url: URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "shopicruit.myshopify.com"
		components.path = path
		components.queryItems = queryItems

		return components.url
	}
}

extension Endpoint {
	static func products(at page: Int = 1, with accessToken: String = "c32313df0d0ef512ca64d5b336a0d7c6") -> Endpoint {
		return Endpoint(
			path: "/admin/products.json/",
			queryItems: [URLQueryItem(name: "page", value: "\(page)"),
						 URLQueryItem(name: "access_token", value: accessToken)]
		)
	}
}
