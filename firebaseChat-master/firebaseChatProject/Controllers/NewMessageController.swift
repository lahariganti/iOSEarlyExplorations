//
//  NewMessageController.swift
//  firebaseChatProject
//
//  Created by Lahari Ganti on 12/23/18.
//  Copyright © 2018 Lahari Ganti. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
	
	let cellId = "cell"
	
	var users = [User]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		
		tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
		fetchUser()
    }
	
	func fetchUser() {
		Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: Any] {
				let user = User()
				user.name = dict["name"] as? String
				user.email = dict["email"] as? String
				
				self.users.append(user)
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}, withCancel: nil)
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
		
		let user = users[indexPath.row]
		cell.textLabel?.text = user.name
		cell.detailTextLabel?.text = user.email
		return cell
	}
}

class UserCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
