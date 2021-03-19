//
//  SwitchVC.swift
//  isItColdOutside
//
//  Created by Lahari Ganti on 1/31/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

protocol SwitchDelegate: class {
    func userEneteredANewCityName(city: String)
}

class SwitchVC: UIViewController {
    @IBOutlet weak var cityInputTextField: UITextField!
    @IBOutlet weak var coldOutsideButton: UIButton!

    weak var delegate: SwitchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        coldOutsideButton.addTarget(self, action: #selector(coldOutsideButtonPressed), for: .touchUpInside)
        cityInputTextField.layer.cornerRadius = 8
        cityInputTextField.clipsToBounds = true
        coldOutsideButton.layer.cornerRadius = 8
        coldOutsideButton.clipsToBounds = true
    }

    @objc func coldOutsideButtonPressed() {
        if let cityName = cityInputTextField.text {
            delegate?.userEneteredANewCityName(city: cityName)
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
