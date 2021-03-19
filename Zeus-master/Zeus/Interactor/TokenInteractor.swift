//
//  TokenInteractor.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import Keys

let keys = ZeusKeys()

class TokenInteractor {
    func fetchAccessToken(_ endpoint: Endpoint, completionHandler: @escaping ((AccessToken?, Error?) -> Void)) {
        guard let url = endpoint.url else { return }
        let client_id = keys.clientID
        let client_secret = keys.clientSecret
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let params = "grant_type=client_credentials&client_id=\(client_id)&client_secret=\(client_secret)"
        request.httpBody = params.data(using: .utf8, allowLossyConversion: true)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(nil, error)
            }

            if let data = data {
                if let result = try? JSONDecoder().decode(AccessToken.self, from: data) {
                    completionHandler(result, nil)
                }
            }
        }

        task.resume()
    }
}
