//
//  SelectGenreVC.swift
//  WhatIsThatTune
//
//  Created by Lahari Ganti on 9/4/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class SelectGenreVC: UITableViewController {
	static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]

    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Select genre"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return SelectGenreVC.genres.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = SelectGenreVC.genres[indexPath.row]
		cell.accessoryType = .disclosureIndicator
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			let genre = cell.textLabel?.text ?? SelectGenreVC.genres[0]
			let vc = AddCommentsVC()
			vc.genre = genre
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}
