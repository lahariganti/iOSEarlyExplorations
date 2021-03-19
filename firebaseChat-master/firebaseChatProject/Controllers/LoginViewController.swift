//
//  LoginViewController.swift
//  firebaseChatProject
//
//  Created by Lahari Ganti on 12/23/18.
//  Copyright © 2018 Lahari Ganti. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
	
	let inputsContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 5
		view.layer.masksToBounds = true
		return view
	}()
	
	lazy var loginRegisterButton: UIButton = {
		let button = UIButton(type: .system)
		button.backgroundColor = UIColor(r: 200, g: 48, b: 0)
		button.setTitle("Register", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 5
		button.layer.masksToBounds = true
		
		button.addTarget(self, action: #selector(handleLoginregister), for: .touchUpInside)
		return button
	}()
	
	let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Name"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	let nameSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let emailTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Email"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	let emailSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let passwordTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Password"
		textField.isSecureTextEntry = true
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	let passwordSeparatorView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "lemmaLogo")
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	lazy var loginRegisterSegmentedControl: UISegmentedControl = {
		let sc = UISegmentedControl(items: ["Login", "Register"])
		sc.tintColor = UIColor(r: 200, g: 48, b: 0)
		sc.selectedSegmentIndex = 1
		sc.translatesAutoresizingMaskIntoConstraints = false
		sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
		return sc
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
		
		view.addSubview(inputsContainerView)
		view.addSubview(loginRegisterButton)
		view.addSubview(profileImageView)
		view.addSubview(loginRegisterSegmentedControl)
		
		setupInputsContainerView()
		setupLoginRegisterButton()
		setupProfileImageView()
		setupLoginRegisterSegmentedControl()
		
    }
	
    var profileImageViewHeightAnchor: NSLayoutConstraint?
    
	func setupProfileImageView() {
		profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
		profileImageViewHeightAnchor = profileImageView.heightAnchor.constraint(equalToConstant: 60)
        profileImageViewHeightAnchor?.isActive = true
	}
	
	func setupLoginRegisterSegmentedControl() {
		loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
		loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}
	
	var inputsContainerViewHeightAnchor: NSLayoutConstraint?
	var nameTextFieldHeightAnchor: NSLayoutConstraint?
	var emailTextFieldHeightAnchor: NSLayoutConstraint?
	var passwordTextFieldHeightAnchor: NSLayoutConstraint?
	
	func setupInputsContainerView() {
		inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
		inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
		inputsContainerViewHeightAnchor?.isActive = true
		
		
		for component in [nameTextField, nameSeparatorView, emailTextField, emailSeparatorView, passwordTextField, passwordSeparatorView] {
			inputsContainerView.addSubview(component)
		}
		
		nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
		nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
		nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
		nameTextFieldHeightAnchor?.isActive = true
		
		nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
		nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
		nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
		emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
		emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
		emailTextFieldHeightAnchor?.isActive = true
		
		emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
		emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		
		passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
		passwordTextFieldHeightAnchor?.isActive = true
		
		passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
		passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
		passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
	}
	
	func setupLoginRegisterButton() {
		loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
		loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
		loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return.lightContent
	}
	
}

extension UIColor {
	
	convenience init (r: CGFloat, g: CGFloat, b: CGFloat){
		self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
	}
	
}
