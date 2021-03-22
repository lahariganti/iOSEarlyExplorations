//
//  ResultsVC.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/9/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit

class ResultsVC: UITableViewController {
	var tune: Tune!
	var suggestions = [String]()
	var tunePlayer: AVAudioPlayer!
	private let reuseIdentifier = "resultsCell"

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Genre: \(tune.genre!)"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadTapped))

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		let reference = CKRecord.Reference(recordID: tune.recordID, action: .deleteSelf)
		let pred = NSPredicate(format: "owningTune == %@", reference)
		let sort = NSSortDescriptor(key: "creationID", ascending: true)
		let query = CKQuery(recordType: "Suggestions", predicate: pred)
		query.sortDescriptors = [sort]

		CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [unowned self] results, error in
			if let error = error {
				print(error.localizedDescription)
			} else {
				if let results = results {
					self.parseResults(records: results)
				}
			}
		}
	}

	func parseResults(records: [CKRecord]) {
		var newSuggestions = [String]()

		for record in records {
			newSuggestions.append(record["text"] as! String)
		}

		DispatchQueue.main.async { [unowned self] in
			self.suggestions = newSuggestions
			self.tableView.reloadData()
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 1 {
			return "Suggested songs"
		}

		return nil
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		cell.selectionStyle = .none
		cell.textLabel?.numberOfLines = 0

		if indexPath.section == 0 {
			cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)

			if tune.comments.count == 0 {
				cell.textLabel?.text = "Comments: None"
			} else {
				cell.textLabel?.text = tune.comments
			}
		} else {
			cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)

			if indexPath.row == suggestions.count {
				cell.textLabel?.text = "Add suggestion"
				cell.selectionStyle = .gray
			} else {
				cell.textLabel?.text = suggestions[indexPath.row]
			}
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == 1 && indexPath.row == suggestions.count else { return }

		tableView.deselectRow(at: indexPath, animated: true)

		let ac = UIAlertController(title: "Suggest a song…", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
			if let textField = ac.textFields?[0] {
				if textField.text!.count > 0 {
					self.add(suggestion: textField.text!)
				}
			}
		})

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}

	func add(suggestion: String) {
		let tuneRecord = CKRecord(recordType: "Suggestions")
		let reference = CKRecord.Reference(recordID: tune.recordID, action: .deleteSelf)
		tuneRecord["text"] = suggestion as CKRecordValue
		tuneRecord["owningWhistle"] = reference as CKRecordValue

		CKContainer.default().publicCloudDatabase.save(tuneRecord) { [unowned self] (record, error) in
			DispatchQueue.main.async {
				if error == nil {
					self.suggestions.append(suggestion)
					self.tableView.reloadData()
				} else {
					let ac = UIAlertController(title: "Error", message: "There was a problem submitting your suggestion: \(error!.localizedDescription)", preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(ac, animated: true)
				}
			}
		}
	}

	@objc func downloadTapped() {
		let spinner = UIActivityIndicatorView(style: .gray)
		spinner.tintColor = UIColor.black
		spinner.startAnimating()
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

		CKContainer.default().publicCloudDatabase.fetch(withRecordID: tune.recordID) { [unowned self] record, error in
			if let error = error {
				DispatchQueue.main.async {
					print("Error: \(error.localizedDescription)")
					self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(self.downloadTapped))
				}
			} else {
				if let record = record {
					if let asset = record["audio"] as? CKAsset {
						self.tune.audio = asset.fileURL

						DispatchQueue.main.async {
							self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listen", style: .plain, target: self, action: #selector(self.listenTapped))
						}
					}
				}
			}
		}
	}

	@objc func listenTapped() {
		do {
			tunePlayer = try AVAudioPlayer(contentsOf: tune.audio)
			tunePlayer.play()
		} catch {
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
}
