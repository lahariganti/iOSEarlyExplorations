//
//  Ticket.swift
//  Foil
//
//  Created by Lahari on 06/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import Foundation

import Foundation

// MARK: - TicketElement
struct Ticket: Codable {
    let id: Int
    let route: Route
    let misc: Misc
}

// MARK: - Misc
struct Misc: Codable {
    let requests, pledge: Int
    let weight: String
}

// MARK: - Route
struct Route: Codable {
    let from, to: String
}
