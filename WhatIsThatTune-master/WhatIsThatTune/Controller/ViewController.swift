//
//  ViewController.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/3/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class ViewController: UITableViewController {
	static var isDirty = true
	var tunes = [Tune]()
	private var reuseIdentifier = "Cell"
	var tune: Tune!
	var suggestions = [String]()
	var tunePlayer: AVAudioPlayer!

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
		tableView.dataSource = self
		view.backgroundColor = .white
		title = "What is that tune?"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTune))
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Genres", style: .plain, target: self, action: #selector(selectGenre))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}

		if ViewController.isDirty {
			loadTunes()
		}
	}

	@objc func addTune() {
		let vc = RecordTuneVC()
		navigationController?.pushViewController(vc, animated: true)
	}

	func loadTunes() {
		let pred = NSPredicate(value: true)
		let sort = NSSortDescriptor(key: "creationDate", ascending: true)
		let query = CKQuery(recordType: "Tunes", predicate: pred)
		query.sortDescriptors = [sort]

		let operation = CKQueryOperation(query: query)
		operation.desiredKeys = ["genre", "comments"]
		operation.resultsLimit = 50

		var newTunes = [Tune]()

		operation.recordFetchedBlock = { record in
			let tune = Tune()
			tune.recordID = record.recordID
			tune.genre = record["genre"]
			tune.comments = record["comments"]
			newTunes.append(tune)
		}

		operation.queryCompletionBlock = { [unowned self] (cursor, error) in
			DispatchQueue.main.async {
				if error == nil {
					ViewController.isDirty = false
					self.tunes = newTunes
					self.tableView.reloadData()
				} else {
					let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
					ac.addAction(UIAlertAction(title: "OK", style: .default))
					self.present(ac, animated: true)
				}
			}
		}

		CKContainer.default().publicCloudDatabase.add(operation)
	}
}

extension ViewController {
	func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
		let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
		let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]

		let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)

		if subtitle.count > 0 {
			let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
			titleString.append(subtitleString)
		}

		return titleString
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tunes.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.attributedText =  makeAttributedString(title: tunes[indexPath.row].genre, subtitle: tunes[indexPath.row].comments)
		cell.textLabel?.numberOfLines = 0
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ResultsVC()
		vc.tune = tunes[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}

	@objc func selectGenre() {
		let vc = MyGenresVC()
		navigationController?.pushViewController(vc, animated: true)
	}
}
