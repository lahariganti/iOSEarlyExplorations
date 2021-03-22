//
//  AppDelegate.swift
//  Record
//
//  Created by Lahari Ganti on 10/7/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	var window: UIWindow?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
		window?.makeKeyAndVisible()
		window?.rootViewController = UINavigationController(rootViewController: HomeVC())


		UNUserNotificationCenter.current().delegate = self


		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				print("D'oh: \(error.localizedDescription)")
			} else {
				DispatchQueue.main.async {
					application.registerForRemoteNotifications()
				}
			}
		}
		
		return true
	}
}

