//
//  UIImageView+Kioku.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/23/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
	func loadImageUsingCacheWithUrlString(_ urlString: String) {
		self.image = nil
		if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
			self.image = cachedImage
			return
		}

		let url = URL(string: urlString)
		URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
			if let error = error {
				print(error)
				return
			}

			DispatchQueue.main.async(execute: {
				guard let data = data else { return }

				if let downloadedImage = UIImage(data: data) {
					imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
					self.image = downloadedImage
				}
			})
		}).resume()
	}
}
