//
//  Endpoint.swift
//  Foil
//
//  Created by Lahari on 06/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.myjson.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}

extension Endpoint {
    static func tickets() -> Endpoint {
        return Endpoint(path: "/bins/vl354", queryItems: nil)
    }
}
