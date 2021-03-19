//
//  PhotoCell.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/16/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import TriangleStaff

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }

    func configure(with photo: Photo) {
        guard let photoURLString = photo.urls?.regular else { return }
        guard let photoURL = URL(string: photoURLString) else { return }
        imageView.setImage(url: photoURL, placeholderImage: UIImage(named: "placeholder")) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        let user = photo.user
        guard let profileImageURLString = user?.profileImage?.small else { return }
        guard let profileImageURL = URL(string: profileImageURLString) else { return }
        profileImageView.setImage(url: profileImageURL, placeholderImage: nil) { (error) in
            if let error = error {
                print(error)
            }
        }

        userNameLabel.text = user?.username

        guard let dateString = photo.createdAt else { return }
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateString)
        let timeAgo = date?.timeAgo(numericDates: true)
        dateLabel.text = timeAgo
    }
}
