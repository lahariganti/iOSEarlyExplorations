//
//  PhotoStreamVC.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/14/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class PhotoStreamVC: UICollectionViewController {
    private let reuseIdentifier = "PhotoCell"
    let photoInteractor = PhotoInteractor()
    var fetchingMore: Bool = false
    var photos = [Photo]()

    override func viewDidLoad() {
        title = "Minerva"
        super.viewDidLoad()
        fetchPhotos()
        configureCollectionView()
    }

    func configureCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }

    func fetchPhotos() {
        photoInteractor.fetchPhotos { (photos, error) in
            if let error = error {
                print(error)
            } else {
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

extension PhotoStreamVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.configure(with: photos[indexPath.row])
        return cell
    }

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height {
//            if !MinervaingMore {
//                beginBatchMinerva()
//            }
//        }
//    }

//    func beginBatchMinerva() {
//        fetchingMore = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            var newPhotos = [Photo]()
//            self.photoInteractor.fetchPhotos(completionHandler: { (photos, error) in
//                newPhotos.append(photos.last!)
//            })
//            self.photos += newPhotos
//            self.fetchingMore = false
//            self.collectionView.reloadData()
//        }
//
//    }
}

extension PhotoStreamVC : PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let height = photos[indexPath.item].height else { return 100.0 }
        return CGFloat(height) * 0.15
    }
}
