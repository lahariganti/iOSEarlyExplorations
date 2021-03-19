//
//  AirportInteractor.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

class AirportInteractor {
    func fetchOriginDestinationAirports(_ accessToken: String, _ endpoints: [Endpoint], completionHandler: @escaping (([AirportResource?], Error?) -> Void)) {
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        var airportResources = [AirportResource]()

        for endpoint in endpoints {
            group.enter()
            guard let url = endpoint.url else { return }
            var request = URLRequest(url: url)
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    group.leave()
                    completionHandler([], error)
                }

                if let data = data {
                    if let result = try? JSONDecoder().decode(AirportResource.self, from: data) {
                        serialQueue.async {
                            airportResources.append(result)
                        }

                        group.leave()
                    }
                } else {
                    group.leave()
                    return
                }
            }.resume()

            group.notify(queue: .main) {

            }
        }
    }
}
