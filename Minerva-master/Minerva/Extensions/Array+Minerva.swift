//
//  Array+Minerva.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/21/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
