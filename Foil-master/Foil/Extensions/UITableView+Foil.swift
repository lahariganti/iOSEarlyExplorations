//
//  UITableView+Foil.swift
//  FoilMusic
//
//  Created by Lahari on 01/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueNibCell<Cell: UITableViewCell>(cellClass: Cell.Type, identifier: String? = nil) -> Cell {
        let cellName = String(describing: cellClass)
        let identifer = identifier ?? cellName
        if let cell = dequeueReusableCell(withIdentifier: identifer) as? Cell {
            return cell
        }
        
        let nib = UINib(nibName: cellName, bundle: nil)
        register(nib, forCellReuseIdentifier: identifer)
        return dequeueReusableCell(withIdentifier: identifer) as! Cell
    }
    
    func configureForFoil() {
        backgroundView = UIImageView(image: UIImage(named: "background"))
        estimatedRowHeight = 420
        rowHeight = UITableView.automaticDimension
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        allowsSelection = false
    }
}
