//
//  AccessoryView.swift
//  Record
//
//  Created by Lahari Ganti on 10/15/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

protocol AccessoryViewDelegate: class {
	func didTapPlayImageView(of record: Record)
	func didTapDeleteImageView(of record: Record)
}

class AccessoryView: UIStackView {
	var record: Record?
	weak var delegate: AccessoryViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

	let playImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "play"))
		imageView.isUserInteractionEnabled = true
		return imageView
	}()

	let deleteImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(named: "delete"))
		imageView.isUserInteractionEnabled = true
		return imageView
	}()

	private func commonInit() {
		distribution = .equalSpacing
		alignment = .center
		spacing = 10
		addArrangedSubviews(playImageView, deleteImageView)
		playImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playImageViewTapped)))
		deleteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteImageViewTapped)))
	}

	func configure(with record: Record) {
		self.record = record
	}

	@objc func playImageViewTapped() {
		if let record = record {
			delegate?.didTapPlayImageView(of: record)

			if !record.audioIsPlaying {
				playImageView.image = UIImage(named: "stop")
			} else {
				playImageView.image = UIImage(named: "play")
			}
		}
	}

	@objc func deleteImageViewTapped() {
		deleteImageView.tintColor = .recordRed
		if let record = record {
			delegate?.didTapDeleteImageView(of: record)
		}
	}
}
