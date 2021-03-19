//
//  AirportCell.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class AirportCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with schedule: Schedule) {
        guard let flight = schedule.flight?.first else { return }
        if let departureCode = flight.departure?.airportCode, let arrivalCode = flight.arrival?.airportCode {
            textLabel?.text = "\(departureCode) ➔ \(arrivalCode)"
        }

        if
            let airlineID = flight.marketingCarrier?.airlineID,
            let flightNumber = flight.marketingCarrier?.flightNumber,
            let numberOfStops = flight.details?.stops?.stopQuantity
        {
            detailTextLabel?.text = "\(airlineID) - \(flightNumber) | \(numberOfStops) stops"
        }

    }
}
