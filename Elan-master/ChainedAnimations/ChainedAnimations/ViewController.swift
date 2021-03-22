//
//  ViewController.swift
//  ChainedAnimations
//
//  Created by Lahari Ganti on 4/1/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let date = dateFormatter.string(from: Date())
        label.text = "\(date)"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "Futura", size: 50)
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "gotta keep moving"
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont(name: "Futura", size: 32)
        return label
    }()

    fileprivate func setupStackView(_ verticalStackView: UIStackView) {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10.0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        let verticalStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.bodyLabel])
        self.view.addSubview(verticalStackView)
        setupStackView(verticalStackView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimations)))
    }

    @objc private func handleTapAnimations() {
        print("animation")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.titleLabel.alpha = 0
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -150)
            })
        }

        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bodyLabel.alpha = 0
                self.bodyLabel.transform = CGAffineTransform(translationX: 0, y: -150)
            })
        }
    }
}

