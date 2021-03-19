//
//  UIImageView+TriangleStaff.swift
//  TriangleStaff
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    func setImage(url: URL, completion: @escaping (_ error : Error?) -> Void) {
        self.setImage(url: url, placeholderImage: nil, completion: completion)
    }

    func setImage(url: URL) {
        self.setImage(url: url, placeholderImage: nil, completion: nil)
    }

    func setImage(url: URL, placeholderImage: UIImage? = nil, completion: ((_ error : Error?) -> Void)?) {
        self.image = nil
        if let placeholderImage = placeholderImage {
            self.image = placeholderImage
        }

        if let cachedImage = CacheManager.sharedCache.unarchiveImage(url: url.absoluteString) {
            self.image = cachedImage
            if let completion = completion {
                completion(nil)
            }
            return
        }

        download(url: url).getImage { (url, image, error) -> Void in
            if error == nil, let image = image {
                self.image = image
                CacheManager.sharedCache.archiveImage(image: image, url: url.absoluteString)
                if let completion = completion {
                    completion(nil)
                }
            } else {
                if let completion = completion {
                    completion(error)
                }
            }
        }
    }
}
