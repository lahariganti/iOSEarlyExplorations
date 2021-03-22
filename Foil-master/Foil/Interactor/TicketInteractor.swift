//
//  TicketInteractor.swift
//  Foil
//
//  Created by Lahari on 06/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import Foundation

class TicketInteractor {
    func fetchTickets(from endpoint: Endpoint, completionHandler: @escaping (([Ticket], Error?) -> Void)) {
        guard let url = endpoint.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completionHandler([], error)
            }

            if let jsonData = data {
                guard let tickets = try? JSONDecoder().decode([Ticket].self, from: jsonData) else { return }
                completionHandler(tickets, nil)
            }
        }

        task.resume()
    }
}
