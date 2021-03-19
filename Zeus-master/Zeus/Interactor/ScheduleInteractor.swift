//
//  ScheduleInteractor.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/4/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

//add error presenter

class ScheduleInteractor {
    func fetchSchedule(_ accessToken: String, _ endpoint: Endpoint, completionHandler: @escaping ((ScheduleResource?, Error?) -> Void)) {
        guard let url = endpoint.url else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            }

            if let data = data {
                guard let result = try? JSONDecoder().decode(ScheduleResource.self, from: data) else { return }
                completionHandler(result, nil)
            }
        }

        task.resume()
    }
}
