//
//  ViewController.swift
//  firebaseChatProject
//
//  Created by Lahari Ganti on 12/23/18.
//  Copyright © 2018 Lahari Ganti. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
//		let image = UIImage(named: "create")
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleCreateMessage))
		checkIfUserIsLoggedIn()
	}
	
	@objc func handleCreateMessage() {
		let newMessageVC = UINavigationController(rootViewController: NewMessageController())
		present(newMessageVC, animated: true, completion: nil)
	}
	
	func checkIfUserIsLoggedIn() {
		if Auth.auth().currentUser?.uid == nil {
			perform(#selector(handleLogout), with: nil, afterDelay: 0)
		} else {
			let uid = Auth.auth().currentUser?.uid
			Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
				if let dict = snapshot.value as? [String: Any] {
					self.navigationItem.title = dict["name"] as? String
				}
			}, withCancel: nil)
		}
	}
	
	@objc func handleLogout() {
		
		do {
			try Auth.auth().signOut()
		} catch let logoutError {
			print(logoutError)
		}
		
		let loginVC = LoginViewController()
		present(loginVC, animated: true, completion: nil)
	}
	
}

