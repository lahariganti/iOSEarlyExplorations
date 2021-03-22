//
//  RootViewController.swift
//  1PasswordDemo
//
//  Created by Lahari on 18/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit
import MessageUI

class RootViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "lain"))
    private lazy var errorPresenter = ErrorPresenter(baseVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.title = "1Password Demo"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(actionButtonTapped))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.frame = self.view.frame
    }
    
    private func setupSubviews() {
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
    }
    
    @objc func actionButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["gplahari@gmail.com"])
            mailComposerVC.navigationBar.tintColor = UIColor.onePasswordBlue
            mailComposerVC.setMessageBody(
                   UIDevice.current.supportInfo,
                   isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            errorPresenter.present(error: OnePasswordError.emailNotSetup.error)
            print("Your device is not set up to sending email")
        }
    }
}

extension RootViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
