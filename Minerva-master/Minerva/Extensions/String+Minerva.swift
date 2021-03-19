//
//  String+Minerva.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }
}
