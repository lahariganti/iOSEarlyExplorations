//
//  ConversionVC.swift
//  BTCC
//
//  Created by Lahari Ganti on 4/23/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class ConversionVC: UIViewController {
    @IBOutlet weak var conversionFactorLabel: UILabel!
    var currency: String
    var conversionFactor: Double = 0.0

    init(currency: String) {
        self.currency = currency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Currencies", style: .plain, target: self, action: #selector(backButtonPressed))
        fetchConversionFactor()
    }

    func fetchConversionFactor() {
        ConversionInteractor.shared.fetchItems(selectedCurrency: currency) { (currency, error) in
            guard error == nil else { return }
            self.conversionFactor = currency.conversionFactor
            DispatchQueue.main.async {
                self.conversionFactorLabel.text = "\(self.conversionFactor)"
            }
        }
    }

    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
