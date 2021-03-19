//
//  SearchFlightVC.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/2/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import Eureka
import SuggestionRow

class SearchFlightVC: FormViewController {
    var airports = [LocalFileAirport]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchButtonPressed))
        getAirportsFromLocalJSON()
        setupForm()
    }

    private func getAirportsFromLocalJSON() {
        guard let path = Bundle.main.url(forResource: "Airports", withExtension: "json") else { return }
        guard let contents = try? Data(contentsOf: path) else { return }
        guard let airports = try? JSONDecoder().decode([LocalFileAirport].self, from: contents) else { return }
        self.airports = airports
    }

    private func setupForm() {
        form = Section()
        +++ Section("Trip Details")
            <<< SuggestionTableRow<LocalFileAirport>() {
                $0.filterFunction = { text in
                    self.airports.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
                }
                $0.placeholder = "Search for an airport"
                $0.title = "From"
                $0.tag = "origin"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }

            <<< SuggestionTableRow<LocalFileAirport>() {
                $0.filterFunction = { text in
                    self.airports.filter({ $0.name?.lowercased().contains(text.lowercased()) ?? false })
                }
                $0.placeholder = "Search for an airport"
                $0.title = "To"
                $0.tag = "destination"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }

            <<< DateRow() {
                $0.title = "🛫 Departure"
                $0.noValueDisplayText = "Select Date"
                $0.tag = "date"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.tintColor = .red
                    }
                }.onCellSelection({ (dateCell, dateRow) in
                    if dateRow.value == nil {
                        dateRow.value = Date()
                        dateRow.updateCell()
                    }
                })
    }

    private func fetchFormValues() -> (String, String, Date) {
        let values = form.values()
        var fromAirportCode: String!
        var toAirportCode: String!
        var fromDate: Date!

        if
            let origin = values["origin"] as? LocalFileAirport,
            let fromCode = origin.iata
        {
            fromAirportCode = fromCode
        }

        if
            let destination = values["destination"] as? LocalFileAirport,
            let toCode = destination.iata
        {
            toAirportCode = toCode
        }

        if let date = values["date"] as? Date {
            fromDate = date
        }

        return (fromAirportCode, toAirportCode, fromDate)
    }

    @objc func searchButtonPressed() {
        if form.validate().isEmpty {
            let res = fetchFormValues()
            let vc = FlightScheduleVC(fromAirportCode: res.0, toAirportCode: res.1, fromDate: res.2)
            navigationController?.pushViewController(vc, animated: true)
        }

    }
}
