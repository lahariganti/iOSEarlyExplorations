//
//  DiscardableData.swift
//  TriangleStaff
//
//  Created by Lahari Ganti on 6/17/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

open class DiscardableData: NSObject, NSDiscardableContent {
    public private(set) var data : Data?
    var counter : UInt = 0

    public init(data: Data) {
        self.data = data
    }

    public func beginContentAccess() -> Bool {
        if data == nil {
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
            data = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        return data == nil ? true : false
    }
}
