//
//  LocalFileAirport.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/3/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import SuggestionRow

struct LocalFileAirport: Codable {
    let iata: String?
    let name: String?
}

extension LocalFileAirport: SuggestionValue {
    var suggestionString: String {
        if let name = name {
            return "\(name)"
        }

        return ""
    }

    init?(string stringValue: String) {
        return nil
    }
}
