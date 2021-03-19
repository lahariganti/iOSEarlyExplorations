//
//  LetterCell.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//


import UIKit

class LetterCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        clipsToBounds = true
    }

    func configure(with label: Label) {
        letterLabel.text = "\(label.letter)"
    }
}
