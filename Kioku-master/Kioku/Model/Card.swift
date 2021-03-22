//
//  Card.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

class Card {
	let id: Int
	var product: ProductElement?
	var shown: Bool = false

	init(id: Int) {
		self.id = id
	}

	func equals(_ card: Card) -> Bool {
		return (card.id == id)
	}
}
