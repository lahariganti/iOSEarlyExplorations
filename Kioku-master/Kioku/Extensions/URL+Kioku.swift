//
//  URL+Kioku.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

extension URL {
	init(staticString string: StaticString) {
		guard let url = URL(string: "\(string)") else {
			preconditionFailure("Invalid static URL string: \(string)")
		}

		self = url
	}
}
