//
//  URL+Zeus.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func accessToken() -> Endpoint {
        return Endpoint(
            path: "/v1/oauth/token/",
            queryItems: []
        )
    }

    static func airport(with code: String) -> Endpoint {
        return Endpoint(
            path: "/v1/mds-references/airports/\(code)/",
            queryItems: []
        )
    }

    static func schedules(origin: String, destination: String, fromDateTime: Date) -> Endpoint {
        var dateString: String = ""
        let components = Calendar.current.dateComponents([.day, .year, .month], from: fromDateTime)
        if let year = components.year, let month = components.month, let day = components.day {
             dateString = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
        }

        return Endpoint(
            path: "/v1/operations/schedules/\(origin)/\(destination)/\(dateString)/",
            queryItems: []
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.lufthansa.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}
