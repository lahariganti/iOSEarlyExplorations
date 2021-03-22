//
//  UIDevice+1Password.swift
//  1PasswordDemo
//
//  Created by Lahari on 18/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
          guard let value = element.value as? Int8, value != 0 else {
            return identifier
          }
          return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }

    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var supportInfo: String {
        let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let iOSVersion = self.systemVersion
        let model = self.modelName
        let info = String.init(
          format: "- - - - - - - - - -\n" +
            "Version: %@\n" +
            "Build: %@\n" +
            "iOS: %@\n" +
            "Device: %@\n" +
          "- - - - - - - - - -", version, build, iOSVersion, model)
        return info
    }
}
