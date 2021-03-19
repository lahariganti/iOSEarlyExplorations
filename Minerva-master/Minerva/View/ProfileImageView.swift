//
//  ProfileImageView.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.minervaBlue.cgColor
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
