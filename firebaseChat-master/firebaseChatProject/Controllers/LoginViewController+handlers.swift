//
//  LoginViewController+handlers.swift
//  firebaseChatProject
//
//  Created by Lahari Ganti on 12/23/18.
//  Copyright © 2018 Lahari Ganti. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@objc func handleSelectProfileImageView() {
		let picker = UIImagePickerController()
		
		picker.delegate = self
		picker.allowsEditing = true
		
		present(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		var selectedImageFromPicker: UIImage?
		
		if let editedImage = info[.editedImage] as? UIImage {
			selectedImageFromPicker = editedImage
		} else if let originmalImage = info[.originalImage] as? UIImage {
			selectedImageFromPicker = originmalImage
		}
		
		if let selectedImage = selectedImageFromPicker {
			profileImageView.image = selectedImage
            profileImageViewHeightAnchor?.constant = 200
		}
		dismiss(animated: true, completion: nil)
	}
	
	@objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func handleLoginregister() {
		if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
			handleLogin()
		} else {
			handleRegister()
		}
	}
	
	@objc func handleLogin() {
		guard let email = emailTextField.text, let password = passwordTextField.text else {
			print("Invalid Form")
			return
		}
		
		Auth.auth().signIn(withEmail: email, password: password) { (User, error) in
			if error != nil {
				print(error as Any)
				return
			}
			
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@objc func handleRegister() {
		guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
			print("Invalid Form")
			return
		}
		
		Auth.auth().createUser(withEmail: email, password: password, completion: { (User, error) in
			
			if error != nil {
				print(error!)
				return
			}
			
			guard let uid = User?.user.uid else {
				return
			}
			
			let storageRef = Storage.storage().reference().child("testImageNew.png")
			if let uploadData = self.profileImageView.image?.pngData() {
				storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
					if error != nil {
                        print(error!)
						return
					}
					
					storageRef.downloadURL(completion: { (url, error) in
						if error != nil {
							print(error!)
							return
						}
						
						if let downloadURL = url?.absoluteString {
							let values = ["name": name, "email": email, "profileImageURL": downloadURL] as [String : Any]
							self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
						}
					})
				})
			}
		})
	}
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference(fromURL: "https://fir3bas3chatproj3ct.firebaseio.com")
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
	
	@objc func handleLoginRegisterChange() {
		let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
		loginRegisterButton.setTitle(title, for: .normal)
		
		inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
		
		nameTextFieldHeightAnchor?.isActive = false
		nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
		nameTextFieldHeightAnchor?.isActive = true
		
		emailTextFieldHeightAnchor?.isActive = false
		emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
		emailTextFieldHeightAnchor?.isActive = true
		
		passwordTextFieldHeightAnchor?.isActive = false
		passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
		passwordTextFieldHeightAnchor?.isActive = true
	}
}
