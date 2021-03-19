//
//  BaseVC.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .lemmaRed
        title = "Word Search"
    }
}
