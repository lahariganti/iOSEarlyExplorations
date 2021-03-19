//
//  ScheduleResource.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/4/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

struct ScheduleResource: Codable {
    let scheduleResource: ScheduleResourceClass?

    enum CodingKeys: String, CodingKey {
        case scheduleResource = "ScheduleResource"
    }
}

struct ScheduleResourceClass: Codable {
    let schedule: [Schedule]?

    enum CodingKeys: String, CodingKey {
        case schedule = "Schedule"
    }
}

struct Schedule: Codable {
    let totalJourney: TotalJourney?
    let flight: [Flight]?

    enum CodingKeys: String, CodingKey {
        case totalJourney = "TotalJourney"
        case flight = "Flight"
    }
}

struct Flight: Codable {
    let departure, arrival: Arrival?
    let marketingCarrier: MarketingCarrier?
    let equipment: Equipment?
    let details: Details?
    let operatingCarrier: OperatingCarrier?

    enum CodingKeys: String, CodingKey {
        case departure = "Departure"
        case arrival = "Arrival"
        case marketingCarrier = "MarketingCarrier"
        case equipment = "Equipment"
        case details = "Details"
        case operatingCarrier = "OperatingCarrier"
    }
}

struct Arrival: Codable {
    let airportCode: String?
    let scheduledTimeLocal: ScheduledTimeLocal?
    let terminal: Terminal?

    enum CodingKeys: String, CodingKey {
        case airportCode = "AirportCode"
        case scheduledTimeLocal = "ScheduledTimeLocal"
        case terminal = "Terminal"
    }
}


struct ScheduledTimeLocal: Codable {
    let dateTime: String?

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
    }
}

struct Terminal: Codable {
    let name: Int?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

struct Details: Codable {
    let stops: Stops?
    let daysOfOperation: Int?
    let datePeriod: DatePeriod?

    enum CodingKeys: String, CodingKey {
        case stops = "Stops"
        case daysOfOperation = "DaysOfOperation"
        case datePeriod = "DatePeriod"
    }
}

struct DatePeriod: Codable {
    let effective, expiration: String?

    enum CodingKeys: String, CodingKey {
        case effective = "Effective"
        case expiration = "Expiration"
    }
}

struct Stops: Codable {
    let stopQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case stopQuantity = "StopQuantity"
    }
}

struct Equipment: Codable {
    let aircraftCode: AircraftCode?
    let onBoardEquipment: OnBoardEquipment?

    enum CodingKeys: String, CodingKey {
        case aircraftCode = "AircraftCode"
        case onBoardEquipment = "OnBoardEquipment"
    }
}

enum AircraftCode: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(AircraftCode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AircraftCode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

struct OnBoardEquipment: Codable {
    let inflightEntertainment: Bool?
    let compartment: [Compartment]?

    enum CodingKeys: String, CodingKey {
        case inflightEntertainment = "InflightEntertainment"
        case compartment = "Compartment"
    }
}

struct Compartment: Codable {
    let classCode, classDesc: String?
    let flyNet, seatPower, usb, liveTv: Bool?

    enum CodingKeys: String, CodingKey {
        case classCode = "ClassCode"
        case classDesc = "ClassDesc"
        case flyNet = "FlyNet"
        case seatPower = "SeatPower"
        case usb = "Usb"
        case liveTv = "LiveTv"
    }
}

struct MarketingCarrier: Codable {
    let airlineID: String?
    let flightNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airlineID = "AirlineID"
        case flightNumber = "FlightNumber"
    }
}

struct OperatingCarrier: Codable {
    let airlineID: String?

    enum CodingKeys: String, CodingKey {
        case airlineID = "AirlineID"
    }
}

struct TotalJourney: Codable {
    let duration: String?

    enum CodingKeys: String, CodingKey {
        case duration = "Duration"
    }
}
