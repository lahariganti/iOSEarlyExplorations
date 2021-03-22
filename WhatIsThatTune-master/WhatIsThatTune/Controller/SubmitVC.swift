//
//  SubmitVC.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/8/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import CloudKit

class SubmitVC: UIViewController {
	var genre: String!
	var comments: String!

	var stackView: UIStackView!
	var status: UILabel!
	var spinner: UIActivityIndicatorView!

	override func loadView() {
		view = UIView()
		view.backgroundColor = .gray

		stackView = UIStackView()
		stackView.spacing = 10
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.alignment = .center
		stackView.axis = .vertical

		view.addSubview(stackView)

		stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		status = UILabel()
		status.translatesAutoresizingMaskIntoConstraints = false
		status.text = "Submitting…"
		status.textColor = UIColor.white
		status.font = UIFont.preferredFont(forTextStyle: .title1)
		status.numberOfLines = 0
		status.textAlignment = .center

		spinner = UIActivityIndicatorView(style: .whiteLarge)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.hidesWhenStopped = true
		spinner.startAnimating()

		stackView.addArrangedSubview(status)
		stackView.addArrangedSubview(spinner)

	}

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "You're all set!"
		navigationItem.hidesBackButton = true
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)

		submit()
	}

	func submit() {
		let tuneRecord = CKRecord(recordType: "Tunes")
		tuneRecord["genre"] = genre as CKRecordValue
		tuneRecord["comments"] = comments as CKRecordValue

		let audioURL = RecordTuneVC.getTuneURL()
		let tuneAsset = CKAsset(fileURL: audioURL)
		tuneRecord["audio"] = tuneAsset


		CKContainer.default().publicCloudDatabase.save(tuneRecord) { [unowned self] record, error in
			if let error = error {
				self.status.text = "Error: \(error.localizedDescription)"
				 self.spinner.stopAnimating()
			} else {
				DispatchQueue.main.async {
					self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
					self.status.text = "Done!"
					self.spinner.stopAnimating()
				}
				
				ViewController.isDirty = true
			}

			self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))

		}
	}

	@objc func doneTapped() {
		navigationController?.popToRootViewController(animated: true)
	}
}
