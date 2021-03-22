//
//  SubmitVC.swift
//  Record
//
//  Created by Lahari Ganti on 10/8/19.
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
	let recordingsInteractor = RecordingsInteractor()
	lazy var errorPresenter = ErrorPresenter(baseVC: self)

	override func loadView() {
		view = UIView()
		view.backgroundColor = .darkGray

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
		status.textColor = UIColor.white
		status.font = UIFont.preferredFont(forTextStyle: .title1)
		status.numberOfLines = 0
		status.textAlignment = .center

		spinner = UIActivityIndicatorView(style: .whiteLarge)
		spinner.translatesAutoresizingMaskIntoConstraints = false
		spinner.hidesWhenStopped = true
		spinner.startAnimating()

		stackView.addArrangedSubviews(status, spinner)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.hidesBackButton = true
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		submit()
	}

	func submit() {
		status.text = "Submitting . . ."
		title = "You are all set!"
		let audioRecord = CKRecord(recordType: "Records")
		let audioURL = HomeVC.getAudioURL()
		let audioAsset = CKAsset(fileURL: audioURL)
		audioRecord["audio"] = audioAsset

		recordingsInteractor.saveRecording(audioRecord) { (record, error) in
			if let _ = error {
				DispatchQueue.main.async {
					self.spinner.stopAnimating()
					self.errorPresenter.present(error: RecordLocalError.save.error)
				}

				DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
					self.navigationController?.popViewController(animated: true)
				}

			} else {
				DispatchQueue.main.async {
					self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
					self.status.text = "Done!"
					self.spinner.stopAnimating()
				}

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
}
