//
//  Game.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

protocol GameDelegate {
	func gameDidStart(_ game: Game)
	func gameDidEnd(_ game: Game)
	func game(_ game: Game, showCards cards: [Card])
	func game(_ game: Game, hideCards cards: [Card])
	func game(_ tracker: Int)
}

class Game {
	var delegate: GameDelegate?
	var cards = [Card]()
	var cardsShown = [Card]()
	var isActive: Bool = false
	var tracker: Int = 0 {
		willSet(currentTracker) {
			delegate?.game(currentTracker)
		}
	}

	func newGame(arrayOfCards: [Card]) -> [Card] {
		cards = shuffleCards(cards: arrayOfCards)
		isActive = true
		delegate?.gameDidStart(self)
		return cards
	}

	func restartGame() {
		isActive = false
		tracker = 0

		cards.removeAll()
		cardsShown.removeAll()
	}

	func endGame() {
		isActive = false
		delegate?.gameDidEnd(self)
	}
}

extension Game {
	func cardAtIndex(_ index: Int) -> Card? {
		if cards.count > index {
			return cards[index]
		} else {
			return nil
		}
	}

	func indexForCard(_ card: Card) -> Int? {
		for index in 0...cards.count-1 {
			if card === cards[index] {
				return index
			}
		}
		return nil
	}

	func didSelectCard(_ card: Card?) {
		guard let card = card else { return }
		delegate?.game(self, showCards: [card])
		if unmatchedCardShown() {
			guard let unmatched = unmatchedCard() else { return }
			if card.equals(unmatched) {
				cardsShown.append(card)
				tracker += 1
			} else {
				let secondCard = cardsShown.removeLast()
				let delayTime = DispatchTime.now() + 1.0
				DispatchQueue.main.asyncAfter(deadline: delayTime) {
					self.delegate?.game(self, hideCards: [card, secondCard])
				}
			}

		} else {
			cardsShown.append(card)
		}

		if cardsShown.count == cards.count {
			endGame()
		}
	}

	fileprivate func unmatchedCardShown() -> Bool {
		return cardsShown.count % 2 != 0
	}

	fileprivate func unmatchedCard() -> Card? {
		let unmatchedCard = cardsShown.last
		return unmatchedCard
	}

	fileprivate func shuffleCards(cards: [Card]) -> [Card] {
		var randomCards = cards
		randomCards.shuffle()

		return randomCards
	}
}
