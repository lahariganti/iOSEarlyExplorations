//
//  KiokuFooter.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
	let inset = UIEdgeInsets(top: -4, left: 4, bottom: -4, right: 4)
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: inset))
	}

	override var intrinsicContentSize: CGSize {
		var intrinsicContentSize = super.intrinsicContentSize
		intrinsicContentSize.width += inset.left + inset.right
		intrinsicContentSize.height += inset.top + inset.bottom
		return intrinsicContentSize
	}
}

func seconds2Timestamp(intSeconds: Int) -> String {
	let mins: Int = intSeconds / 60
	let hours: Int = mins / 60
	let secs: Int = intSeconds % 60

	let strTimestamp: String = ((hours < 10) ? "0" : "") + String(hours) + ":" + ((mins < 10) ? "0" : "") + String(mins) + ":" + ((secs < 10) ? "0" : "") + String(secs)
	return strTimestamp
}

class KiokuFooter: UICollectionReusableView {
	var timerLabel = InsetLabel()
	let scoreLabel = InsetLabel()
	var oldCounterValue: Int = 0
	var newCounterValue: Int = 0

	var tracker: Int = 0 {
		didSet {
			setScore(self.tracker)
		}
	}

	var counter: Int = 0 {
		willSet {
			newCounterValue = newValue
			oldCounterValue = self.counter
		}

		didSet {
			setCounter(self.counter)
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		addSubviews(timerLabel, scoreLabel)

		timerLabel.backgroundColor = .kiokuGreen
		timerLabel.layer.cornerRadius = 10
		timerLabel.clipsToBounds = true
		timerLabel.translatesAutoresizingMaskIntoConstraints = false
		timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
		timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
		timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
		timerLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
		timerLabel.textAlignment = .center

		scoreLabel.backgroundColor = .kiokuBlue
		scoreLabel.layer.cornerRadius = 10
		scoreLabel.clipsToBounds = true
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
		scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
		scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
		scoreLabel.trailingAnchor.constraint(equalTo: timerLabel.leadingAnchor, constant: -20).isActive = true
		scoreLabel.textAlignment = .center
	}

	func commonInit() {
		layer.cornerRadius = 10
		backgroundColor = .lightBackground
		setScore(0)
		setCounter(0)
	}

	private func setScore(_ tracker: Int) {
		let score = counter > 0 && counter < 5 ? 8 : tracker * 2
		let scoreText = "SCORE: \(score)"
		let scoreAttrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
		let scoreAttrText = NSAttributedString(string: scoreText, attributes: scoreAttrs)
		scoreLabel.attributedText = scoreAttrText
	}

	private func setCounter(_ counter: Int) {
		let counterText = seconds2Timestamp(intSeconds: counter)
		let counterAttrs = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
		let counterAttrText = NSAttributedString(string: counterText, attributes: counterAttrs)
		timerLabel.attributedText = counterAttrText
	}
}
