//
//  MenuTableViewCell.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/2/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadCellWithTag(tag: Int)  {
        let highLightColor: UIColor = .darkBackground

        switch tag {
        case 0:
            self.imageView?.image = UIImage(named: "bookFlightIc")
            self.textLabel?.text = "Search Flight"
        case 1:
            self.imageView?.image = UIImage(named: "checkInIc")
            self.backgroundColor = highLightColor
            self.textLabel?.text = "Check In"
            self.disableCell()
        case 2:
            self.imageView?.image = UIImage(named: "flightStatusIc")
            self.textLabel?.text = "Flight Status"
            self.disableCell()
        case 3:
            self.imageView?.image = UIImage(named: "specialOfferIc")
            self.textLabel?.text = "Special Offers"
            self.backgroundColor = highLightColor
            self.disableCell()
        case 4:
            self.imageView?.image = UIImage(named: "InformationIc")
            self.textLabel?.text = "Information"
            self.disableCell()
        case 5:
            self.imageView?.image = UIImage(named: "contactUsIc")
            self.textLabel?.text = "Contact Us"
            self.backgroundColor = highLightColor
            self.disableCell()
        default:
            self.imageView?.image = nil
            self.textLabel?.text = ""
            self.backgroundColor = UIColor.clear
        }
    }

    func disableCell() {
        self.isUserInteractionEnabled = false
        self.textLabel?.isEnabled = false
        self.imageView?.isUserInteractionEnabled = false
    }
}
