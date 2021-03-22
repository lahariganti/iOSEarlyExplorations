//
//  UIView+Record.swift
//  Record
//
//  Created by Lahari Ganti on 10/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

extension UIView {
	func addSubviews(_ views: UIView...) {
		views.forEach{addSubview($0)}
	}
}

extension UIStackView {
	func addArrangedSubviews(_ views: UIView...) {
		views.forEach{addArrangedSubview($0)}
	}
}
