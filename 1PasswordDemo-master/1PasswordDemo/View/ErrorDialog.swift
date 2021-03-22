//
//  ErrorDialog.swift
//  1PasswordDemo
//
//  Created by Lahari on 18/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit

class ErrorDialog: UILabel {
    let error: Error

    init(error: Error) {
        self.error = error
        super.init(frame: .zero)
        backgroundColor = UIColor.onePasswordRed
        textColor = UIColor.white
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
 
