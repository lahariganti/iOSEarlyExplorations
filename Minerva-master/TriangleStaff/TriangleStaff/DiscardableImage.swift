//
//  DiscardableImage.swift
//  TriangleStaff
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation
import UIKit

open class DiscradableImage: NSObject, NSDiscardableContent {
    public private(set) var image : UIImage?
    var counter : UInt = 0

    public init(image: UIImage) {
        self.image = image
    }

    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }

        counter += 1
        return true
    }

    public func endContentAccess() {
        if counter > 0 {
            counter -= 1
        }
    }

    public func discardContentIfPossible() {
        if counter == 0 {
            image = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        return image == nil ? true : false
    }
}
