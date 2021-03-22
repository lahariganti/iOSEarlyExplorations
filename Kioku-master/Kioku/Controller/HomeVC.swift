//
//  HomeVC.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	private let reuseIdentifier = "CardCell"
	private let footerIdentifier = "KiokuFooter"
	let productInteractor = ProductInteractor()
	private lazy var errorPresenter = ErrorPresenter(baseVC: self)
	var products = [ProductElement]()
	var chosenProdcuts = [ProductElement]()
	let game = Game()
	var timer = Timer()

	var cards = [Card]() {
		didSet {
			DispatchQueue.main.async {
				self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "0/\(self.cards.count/2)", style: .plain, target: nil, action: nil)
			}
		}
	}

	var counter: Int = 0 {
		didSet {
			self.isKiokuFooter()?.counter = self.counter
		}
	}

	override func viewDidLoad() {
		title = "Kioku"
        super.viewDidLoad()
		game.delegate = self
		setupNavBar()
		fetchProducts()
		configureCollectionView()
    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if game.isActive {
			resetGame()
		}
	}

	private func setupNavBar() {
		navigationController?.navigationBar.backgroundColor = .white
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetGame))
	}

	private func configureCollectionView() {
		let nib = UINib(nibName: reuseIdentifier, bundle: nil)
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView.register(KiokuFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
		collectionView?.backgroundColor = .kiokuRed
		collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.itemSize = CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height / 8)
			layout.minimumLineSpacing = 20
			layout.minimumInteritemSpacing = 8
			layout.sectionInset =  UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
		}
	}

	private func fetchProducts() {
		productInteractor.fetchProducts(from: .products()) { (product, error) in
			if let error = error {
				print(error)
				DispatchQueue.main.async {
					self.isKiokuFooter()?.isHidden = true
				}

				self.errorPresenter.present(error: KiokuLocalError.noConnection.error)
				return
			} else {
				guard let product = product, let products = product.products else {
					print("product is nil wth")
					DispatchQueue.main.async {
						self.isKiokuFooter()?.isHidden = true
					}
					self.errorPresenter.present(error: KiokuLocalError.generic.error)
					return
				}
				
				self.products = Array(products.prefix(10))
				self.chosenProdcuts = self.products + self.products

				self.chosenProdcuts.forEach({ (product) in
					let newCard = Card(id: product.id ?? 42)
					newCard.product = product
					self.cards.append(newCard)
				})

				DispatchQueue.main.async {
					self.setupNewGame()
				}
			}
		}
	}

	func setupNewGame() {
		cards = game.newGame(arrayOfCards: cards)
		collectionView.reloadData()
	}

	@objc func resetGame() {
		timer.invalidate()
		counter = 0
		game.restartGame()
		setupNewGame()
	}

	@objc func endGame() {
		game.endGame()
	}
}

extension HomeVC {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cards.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
		cell.configure(with: cards[indexPath.row])
		cell.showCard(false, animated: true)
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if counter == 0 {
			timer = Timer.scheduledTimer(
				timeInterval: 1.0,
				target: self,
				selector: #selector(didStartTimer),
				userInfo: nil,
				repeats: true
			)
		}

		let cell = collectionView.cellForItem(at: indexPath) as! CardCell
		if cell.shown { return }
		game.didSelectCard(cards[indexPath.row])
		collectionView.deselectItem(at: indexPath, animated: true)
	}

	@objc func didStartTimer() {
		counter += 1
	}

	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! KiokuFooter
		return footer
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		return CGSize(width: UIScreen.main.bounds.width - 32, height: 42)
	}

	func isKiokuFooter() -> KiokuFooter? {
		return collectionView.visibleSupplementaryViews(ofKind: "UICollectionElementKindSectionFooter").first as? KiokuFooter
	}
}

extension HomeVC: GameDelegate {
	func gameDidStart(_ game: Game) {
		collectionView.reloadData()
	}
	
	func game(_ game: Game, showCards cards: [Card]) {
		for card in cards {
			guard let index = game.indexForCard(card) else { continue }
			let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
			cell.showCard(true, animated: true)
		}
	}

	func game(_ game: Game, hideCards cards: [Card]) {
		for card in cards {
			guard let index = game.indexForCard(card) else { continue }
			let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as! CardCell
			cell.showCard(false, animated: true)
		}
	}

	func gameDidEnd(_ game: Game) {
		timer.invalidate()
		isKiokuFooter()?.tracker = 0

		let alertController = UIAlertController(
			title: "You have lvl'd up.",
			message: "Play again?",
			preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: "No", style: .cancel) { [weak self] (action) in
			self?.collectionView.isHidden = true
			self?.isKiokuFooter()?.isHidden = true
			self?.errorPresenter.present(error: KiokuLocalError.youHadOneChance.error)
		}

		let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (action) in
			self?.resetGame()
		}

		alertController.addAction(cancelAction)
		alertController.addAction(playAgainAction)

		self.present(alertController, animated: true) { }

		resetGame()
	}

	func game(_ tracker: Int) {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "\(tracker)/\(cards.count/2)", style: .plain, target: nil, action: nil)
		self.isKiokuFooter()?.tracker += tracker
	}
}
