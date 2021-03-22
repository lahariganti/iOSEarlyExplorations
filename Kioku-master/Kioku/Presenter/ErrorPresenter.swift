//
//  ErrorPresenter.swift
//  Kioku
//
//  Created by Lahari Ganti on 9/19/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

enum KiokuLocalError {
	case noConnection
	case generic
	case youHadOneChance

	var error: NSError {
		switch self {
		case .generic:
			return NSError(domain: "Error", code: 0, userInfo: ["message": "Failed to load products, creator is a n00b."])
		case .noConnection:
			return NSError(domain: "Error", code: 1, userInfo: ["message": "Couldn't fetch the required data, please check your internet connection."])
		case .youHadOneChance:
			return NSError(domain: "Error", code: 2, userInfo: ["message": "DED, will have to build and run again, hyuk hyuk"])
		}
	}
}

class ErrorPresenter: NSObject {
	private let baseVC: UICollectionViewController
	private var backgroundView: UIView?
	private var currentDialog: ErrorDialog?

	init(baseVC: UICollectionViewController) {
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
			view.backgroundColor = .kiokuLight
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
			UIView.animate(withDuration: 1.0, delay: 4.0, options: .transitionCrossDissolve, animations: {
				view.alpha = 0
			}) { _ in
				view.removeFromSuperview()
				self.baseVC.navigationController?.popViewController(animated: true)
			}
		}
	}
}
