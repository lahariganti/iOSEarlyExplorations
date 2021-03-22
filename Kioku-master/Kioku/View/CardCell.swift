//
//  CardCell.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var frontImageView: UIImageView!
	var shown: Bool = false

	override func awakeFromNib() {
        super.awakeFromNib()
		layer.cornerRadius = 10
		layer.shadowRadius = 20
		layer.shadowOffset = CGSize(width: 20, height: 20)
		layer.shadowOpacity = 0.8
		layer.shadowColor = UIColor.lightBackground.cgColor
    }

	func configure(with card: Card) {
		guard let product = card.product else { return }
		
		if let imageURL = product.image?.src {
			backImageView.loadImageUsingCacheWithUrlString(imageURL)
		}
	}

	func showCard(_ show: Bool, animated: Bool) {
		frontImageView.isHidden = false
		backImageView.isHidden = false
		shown = show

		if animated {
			if show {
				UIView.transition(
					from: frontImageView,
					to: backImageView,
					duration: 0.3,
					options: [.transitionFlipFromRight, .showHideTransitionViews],
					completion: { (finished: Bool) -> () in
				})
			} else {
				UIView.transition(
					from: backImageView,
					to: frontImageView,
					duration: 0.3,
					options: [.transitionFlipFromRight, .showHideTransitionViews],
					completion:  { (finished: Bool) -> () in
				})
			}
		} else {
			if show {
				bringSubviewToFront(backImageView)
				backImageView.isHidden = true
			} else {
				bringSubviewToFront(frontImageView)
				frontImageView.isHidden = true
			}
		}
	}

}
