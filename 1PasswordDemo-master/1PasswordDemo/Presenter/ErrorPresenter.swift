//
//  ErrorPresenter.swift
//  1PasswordDemo
//
//  Created by Lahari on 18/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import Foundation
import UIKit

enum OnePasswordError {
    case emailNotSetup
    case generic

    var error: NSError {
        switch self {
        case .emailNotSetup:
            return NSError(domain: "Error", code: 0, userInfo: ["message": "Email not configured. Please check your mail settings. : ]"])
        case .generic:
            return NSError(domain: "Error", code: 0, userInfo: ["message": "N00B"])
        }
    }
}

class ErrorPresenter: NSObject {
    private let baseVC: UIViewController
    private var backgroundView: UIView?
    private var currentDialog: ErrorDialog?

    init(baseVC: UIViewController) {
        self.baseVC = baseVC
    }

    func present(error: Error) {
        if let view = backgroundView {
            DispatchQueue.main.async {
                view.removeFromSuperview()
            }
            
            backgroundView = nil
            currentDialog = nil
        }

        DispatchQueue.main.async {
            let view = UIView()
            let dialog = ErrorDialog(error: error)
            view.backgroundColor = UIColor.onePasswordRed
            self.backgroundView = view
            self.currentDialog = dialog
            self.baseVC.view.addSubview(view)
            view.addSubview(dialog)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            dialog.translatesAutoresizingMaskIntoConstraints = false
            let constraints: [NSLayoutConstraint] = [ view.widthAnchor.constraint(equalTo: self.baseVC.view.widthAnchor, constant: -64),
                                                      view.heightAnchor.constraint(equalToConstant: 120),
                                                      view.centerXAnchor.constraint(equalTo: self.baseVC.view.centerXAnchor),
                                                      view.centerYAnchor.constraint(equalTo: self.baseVC.view.centerYAnchor),
                                                      dialog.widthAnchor.constraint(equalTo: self.baseVC.view.widthAnchor, constant: -128),
                                                      dialog.heightAnchor.constraint(equalToConstant: 120),
                                                      dialog.centerXAnchor.constraint(equalTo: self.baseVC.view.centerXAnchor),
                                                      dialog.centerYAnchor.constraint(equalTo: self.baseVC.view.centerYAnchor)
                                                    ]
            NSLayoutConstraint.activate(constraints)
            view.alpha = 1.0
            UIView.animate(withDuration: 1.0, delay: 1.0, options: .transitionCrossDissolve, animations: {
                view.alpha = 0
            }) { _ in
                view.removeFromSuperview()
            }
        }
    }
}
