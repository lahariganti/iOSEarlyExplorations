//
//  SpinnerPresenter.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/2/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class SpinnerPresenter: NSObject {
    private let spinner = UIActivityIndicatorView(style: .gray)
    var parentVC: UIViewController?
    let dimView: UIView = UIView()
    let hasDimView: Bool

    init(hasDimView: Bool = false, spinnerStyle: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.gray) {
        self.hasDimView = hasDimView
        spinner.style = spinnerStyle
        super.init()
    }

    func addSpinner(container: UIView? = nil) {
        let containerView = container ?? UIApplication.shared.keyWindow ?? UIView()
        if hasDimView {
            dimView.frame = UIScreen.main.bounds
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            containerView.addSubview(dimView)
        }

        containerView.addSubview(spinner)
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }

    func removeSpinner() {
        dimView.removeFromSuperview()
        spinner.removeFromSuperview()
    }
}
