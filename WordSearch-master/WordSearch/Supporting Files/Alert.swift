//
//  Alert.swift
//  WordSearch
//
//  Created by Lahari Ganti on 5/15/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

struct Alert {
    static func difficultyButtonAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Easy (Default)", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Medium", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
}
