//
//  Array+Kioku.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

extension Array {
	subscript (randomPick n: Int) -> [Element] {
		var copy = self
		for i in stride(from: count - 1, to: count - n - 1, by: -1) {
			copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
		}

		return Array(copy.suffix(n))
	}

	mutating func shuffle() {
		for _ in 0...self.count {
			sort { (_, _) in arc4random() < arc4random() }
		}
	}
}
