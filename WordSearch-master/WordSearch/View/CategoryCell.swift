//
//  CategoryCell.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/14/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var cardShadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var backgroundInnerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 10
        cardShadowView.layer.cornerRadius = 10
        background.layer.cornerRadius = 10
        backgroundInnerView.layer.cornerRadius = 10
        background.backgroundColor = .darkBackground
        selectionStyle = .none
    }

    func configure(with category: Category) {
        categoryNameLabel.text = category.name
        categoryImageView.image = UIImage(named: category.name.lowercased())
    }
}
