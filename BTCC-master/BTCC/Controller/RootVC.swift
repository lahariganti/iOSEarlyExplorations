//
//  RootVC.swift
//  BTCC
//
//  Created by Lahari Ganti on 4/23/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        configureSubViews()
    }

    private func configureSubViews() {
        nameTextField.layer.cornerRadius = 8
        nameTextField.clipsToBounds = true
        nameTextField.setLeftPaddingPoints(10)
        nameTextField.setRightPaddingPoints(10)
    }

    func writeToUserDefaults() {
        guard let userName = nameTextField.text else { return }
        UserDefaults.standard.set(userName, forKey: KeyConstants.userName)
        UserDefaults.standard.synchronize()
    }
}

extension RootVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        writeToUserDefaults()
        present(UINavigationController(rootViewController: WelcomeVC()), animated: true, completion: nil)
        return true
    }
}
