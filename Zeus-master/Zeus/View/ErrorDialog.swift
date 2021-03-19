//
//  ErrorDialog.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/5/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class ErrorDialog: UILabel {
    let error: Error

    init(error: Error) {
        self.error = error
        super.init(frame: .zero)
        backgroundColor = .zeusLight
        textColor = .zeusDark
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        numberOfLines = 0
        sizeToFit()
        textAlignment = .left
        text = String(describing: (error as NSError).userInfo["message"] ?? error.localizedDescription)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
