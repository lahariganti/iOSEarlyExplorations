//
//  CategoryVC.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/14/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class CategoryVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    private let reuseIdentifier = "CategoryCell"

    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        categories = fillUpCategories()
    }
}

private extension CategoryVC {
    func configureTableView() {
        let categoryCell = UINib(nibName: reuseIdentifier, bundle: nil)
        tableView.register(categoryCell, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }

    func fillUpCategories() -> [Category] {
        return [Category(name: "REQUIRED"),
                Category(name: "SWIFT"),
                Category(name: "iOS"),
                Category(name: "IoT"),
                Category(name: "PHILOSOPHY"),
                Category(name: "LAHARI")]
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
}

extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SearchVC(selectedCategory: categories[indexPath.row]), animated: true)
    }
}
