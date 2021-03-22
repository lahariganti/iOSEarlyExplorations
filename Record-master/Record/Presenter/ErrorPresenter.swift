//
//  ErrorPresenter.swift
//  Record
//
//  Created by Lahari Ganti on 10/16/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

enum RecordLocalError {
    case generic
	case save

    var error: NSError {
		switch self {
        case .generic:
            return NSError(domain: "Error", code: 1, userInfo: ["message": "Couldn't fetch the required data, please check your internet connection."])
		case .save:
		return NSError(domain: "Error", code: 2, userInfo: ["message": "Couldn't save the audio clip, creator is a noob."])
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
			view.backgroundColor = .recordRed
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
                                                      dialog.widthAnchor.constraint(equalTo: self.baseVC.view.widthAnchor, constant: -100),
                                                      dialog.heightAnchor.constraint(equalToConstant: 120),
                                                      dialog.centerXAnchor.constraint(equalTo: self.baseVC.view.centerXAnchor),
                                                      dialog.centerYAnchor.constraint(equalTo: self.baseVC.view.centerYAnchor)
                                                    ]
            NSLayoutConstraint.activate(constraints)
            view.alpha = 1.0
            UIView.animate(withDuration: 1.0, delay: 3.0, options: .transitionCrossDissolve, animations: {
                view.alpha = 0
            }) { _ in
                view.removeFromSuperview()
            }
        }
    }
}
