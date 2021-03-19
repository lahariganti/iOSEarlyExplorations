//
//  Category.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/14/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

class Category: Decodable {
    var name: String

    init(name: String) {
        self.name = name
    }
}
