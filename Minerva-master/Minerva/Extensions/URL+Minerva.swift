//
//  URL+Minerva.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/16/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }

        self = url
    }
}
