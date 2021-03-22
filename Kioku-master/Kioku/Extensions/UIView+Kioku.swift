//
//  UIView+Kioku.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

extension UIView {
	func addSubviews(_ views: UIView...) {
		views.forEach{addSubview($0)}
	}
}
