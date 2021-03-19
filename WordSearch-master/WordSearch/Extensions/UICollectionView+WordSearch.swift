//
//  UICollectionView+WordSearch.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

extension UICollectionView {
    func drawLineFrom(
        from: IndexPath,
        to: IndexPath,
        strokeColor: UIColor
        ) {
        guard
            let fromPoint = cellForItem(at: from)?.center,
            let toPoint = cellForItem(at: to)?.center
            else {
                return
        }

        let path = UIBezierPath()

        path.move(to: convert(fromPoint, to: self))
        path.addLine(to: convert(toPoint, to: self))

        let layer = CAShapeLayer()


        layer.path = path.cgPath
        layer.lineWidth = 22
        layer.strokeColor = strokeColor.cgColor
        layer.opacity = 0.3
        layer.lineCap = .round
        
        
        self.layer.addSublayer(layer)
    }
}
