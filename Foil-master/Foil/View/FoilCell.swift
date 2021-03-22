//
//  FoilCell.swift
//  FoilMusic
//
//  Created by Lahari on 01/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit

class FoilCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var requestsLabel: UILabel!
    @IBOutlet weak var pledgeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with ticket: Ticket) {
        idLabel.text = "\(ticket.id)"
        fromAddressLabel.text = "\(ticket.route.from)"
        toAddressLabel.text = ticket.route.to
        requestsLabel.text = "\(ticket.misc.requests)"
        pledgeLabel.text = "\(ticket.misc.pledge)"
        weightLabel.text = "\(ticket.misc.pledge)"
    }
}
