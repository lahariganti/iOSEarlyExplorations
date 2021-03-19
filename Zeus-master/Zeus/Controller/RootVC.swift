//
//  RootVC.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    private let reuseIdentifier = "MenuTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSelf()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            logoHeightConstraint.constant = (UIScreen.main.bounds.height + navBarHeight) * 0.5
        }
        
        tableView.rowHeight = tableView.bounds.height / 8
    }

    private func configureSelf() {
        title = "Zeus"
        navigationController?.navigationBar.barTintColor = .white
    }

    private func configureTableView() {
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

extension RootVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MenuTableViewCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.loadCellWithTag(tag: indexPath.row)
        return cell
    }
}

extension RootVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = SearchFlightVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
