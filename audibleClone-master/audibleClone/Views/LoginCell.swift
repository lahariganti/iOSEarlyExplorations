//
//  LoginCell.swift
//  audibleClone
//
//  Created by Lahari Ganti on 3/27/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        logo.image = UIImage(named: "logo")
        return logo
    }()

    let emailTextField: LeftPaddedTextField = {
        let et = LeftPaddedTextField()
        et.layer.borderColor = UIColor.lightGray.cgColor
        et.layer.borderWidth = 1
        et.placeholder = "Enter email"
        et.translatesAutoresizingMaskIntoConstraints = false
        return et
    }()

    let passwordTextField: LeftPaddedTextField = {
        let pt = LeftPaddedTextField()
        pt.layer.borderColor = UIColor.lightGray.cgColor
        pt.layer.borderWidth = 1
        pt.placeholder = "Enter password"
        pt.isSecureTextEntry = true
        pt.translatesAutoresizingMaskIntoConstraints = false
        return pt
    }()

    let loginButton: UIButton = {
        let lb = UIButton()
        lb.setTitle("Log In", for: .normal)
        lb.setTitleColor(.white, for: .normal)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = .orange
        return lb
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        loginButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        loginButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

class LeftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.width - 8, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.width - 8, height: bounds.height)
    }
}
