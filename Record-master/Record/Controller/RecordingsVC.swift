//
//  RecordingsVC.swift
//  Record
//
//  Created by Lahari Ganti on 10/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class RecordingsVC: UITableViewController {
	var records = [Record]()
	private var reuseIdentifier = "recordingCell"
	var recordPlayer: AVAudioPlayer!
	let recordingsInteractor = RecordingsInteractor()
	lazy var spinnerPresenter = SpinnerPresenter(hasDimView: true, spinnerStyle: .whiteLarge)
	lazy var errorPresenter = ErrorPresenter(baseVC: self)
	var audioDidFinishPlaying: Bool = false {
		didSet {

		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		spinnerPresenter.parentVC = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		tableView.dataSource = self
		view.backgroundColor = .white
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		fetchRecordings()
	}

	func fetchRecordings() {
		spinnerPresenter.addSpinner()
		recordingsInteractor.fetchRecordings({(recordings, error) in
			print(recordings)
			if let error = error {
				print("Error: \(error.localizedDescription)")
				DispatchQueue.main.async {
					self.spinnerPresenter.removeSpinner()
					self.errorPresenter.present(error: RecordLocalError.generic.error)
				}

				DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
					self.navigationController?.popViewController(animated: true)
				}
			} else {
				self.records = recordings
				DispatchQueue.main.async {
					self.tableView.reloadData()
					self.spinnerPresenter.removeSpinner()
				}
			}
		})
	}
}

extension RecordingsVC: AccessoryViewDelegate {
	func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
		let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.recordRed]
		let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]

		let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)

		if subtitle.count > 0 {
			let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
			titleString.append(subtitleString)
		}

		return titleString
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return records.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let record = records[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		cell.selectionStyle = .none
		let accessoryView = AccessoryView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
		accessoryView.configure(with: record)
		cell.accessoryView = accessoryView
		accessoryView.delegate = self
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.attributedText = makeAttributedString(title: record.recordID.recordName, subtitle: record.creationDate.description)
		return cell
	}

	func didTapPlayImageView(of record: Record) {
		recordingsInteractor.fetchSelectedRecord(with: record.recordID, { (url, error) in
			if let error = error {
				DispatchQueue.main.async {
					self.spinnerPresenter.removeSpinner()
					self.errorPresenter.present(error: RecordLocalError.generic.error)
				}
				print("Error: \(error.localizedDescription)")
			} else {
				if let url = url {
					record.audio = url
					DispatchQueue.main.async {
						do {
							if let audio = record.audio {
								self.recordPlayer = try AVAudioPlayer(contentsOf: audio)
								self.recordPlayer.delegate = self
							}

							if record.audioIsPlaying {
								self.recordPlayer.stop()
								record.audioIsPlaying = false
							} else {
								self.recordPlayer.play()
								record.audioIsPlaying = true
							}

							if self.audioDidFinishPlaying {

							}

						} catch {
							print(error)
						}
					}
				}
			}
		})
	}
	

	func didTapDeleteImageView(of record: Record) {
		recordingsInteractor.deleteSelectedRecord(with: record.recordID) { (record, error) in
			if let error = error {
				print("Error: \(error.localizedDescription)")
			} else {
				if let recordToBeRemoved = record {
					self.records.removeAll { (record) -> Bool in
						recordToBeRemoved.recordID == record.recordID
					}
				}

				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
}

extension RecordingsVC: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if flag {
			audioDidFinishPlaying = true
		}
	}
}
