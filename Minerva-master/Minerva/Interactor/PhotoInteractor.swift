//
//  PhotoInteractor.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/18/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class PhotoInteractor: NSObject {
    func fetchPhotos(completionHandler: @escaping (([Photo], Error?) -> Void)) {
        let url = URL(staticString: "https://pastebin.com/raw/wgkJgazE")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler([], error)
                return
            }

            guard let data = data else { return }
            if let photos = try? JSONDecoder().decode(Photos.self, from: data) {
                completionHandler(Photo.parsePhotos(photos: photos), nil)
            }
        }.resume()
    }
}

