//
//  Airport.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

struct AirportResource: Codable {
    let airportResource: AirportResourceClass?

    enum CodingKeys: String, CodingKey {
        case airportResource = "AirportResource"
    }
}

struct AirportResourceClass: Codable {
    let airports: Airports?
    
    enum CodingKeys: String, CodingKey {
        case airports = "Airports"
    }
}

struct Airports: Codable {
    let airport: Airport?

    enum CodingKeys: String, CodingKey {
        case airport = "Airport"
    }
}

struct Airport: Codable {
    let airportCode: String?
    let position: Position?
    let cityCode, countryCode, locationType: String?
    let names: Names?
    let utcOffset, timeZoneID: String?

    enum CodingKeys: String, CodingKey {
        case airportCode = "AirportCode"
        case position = "Position"
        case cityCode = "CityCode"
        case countryCode = "CountryCode"
        case locationType = "LocationType"
        case names = "Names"
        case utcOffset = "UtcOffset"
        case timeZoneID = "TimeZoneId"
    }
}

struct Names: Codable {
    let name: [Name]?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

struct Name: Codable {
    let languageCode, empty: String?

    enum CodingKeys: String, CodingKey {
        case languageCode = "@LanguageCode"
        case empty = "$"
    }
}

struct Position: Codable {
    let coordinate: Coordinate?

    enum CodingKeys: String, CodingKey {
        case coordinate = "Coordinate"
    }
}

struct Coordinate: Codable {
    let latitude, longitude: Double?

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
