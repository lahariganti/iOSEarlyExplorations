//
//  PageCell.swift
//  audibleClone
//
//  Created by Lahari Ganti on 3/25/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    var page: Page? {
        didSet {
            guard let page = page else {
                return
            }

            var imageName = page.imageName
            if UIDevice.current.orientation.isLandscape {
//                imageName = page?.imageName
            }
            imageView.image = UIImage(named: imageName)

            let title = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 32), NSAttributedString.Key.foregroundColor: UIColor(white: 0.2, alpha: 1)])
            let message = NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 1)])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            title.append(message)
            title.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: title.string.count))
            textView.attributedText = title
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "bmx1")
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.text = "WOW WOWWWW"
        tv.contentInset = UIEdgeInsets(top: 24 , left: 16, bottom: 16, right: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(textView)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(){
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true

        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
    }
}
