//
//  UIPanGesture+WordSearch.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

enum Direction: Int {
    case up
    case down
    case left
    case right

    public var isHorizontal: Bool { return self == .left || self == .right }
    public var isVertical: Bool { return !isHorizontal }
}

extension UIPanGestureRecognizer {
    var direction: Direction? {
        let mu = velocity(in: view)
        let vertical = abs(mu.y) > abs(mu.x)

        switch (vertical, mu.x, mu.y) {
            case (true, _, let y) where y < 0: return .up
            case (true, _, let y) where y > 0: return .down
            case (false, let x, _) where x > 0: return .right
            case (false, let x, _) where x < 0: return .left
            default: return nil
        }
    }
}
