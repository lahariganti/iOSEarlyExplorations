//
//  RootVC.swift
//  FoilMusic
//
//  Created by Lahari on 01/01/2020.
//  Copyright © 2020 Lahari Ganti. All rights reserved.
//

import UIKit

class RootVC: UITableViewController {
    let ticketInteractor = TicketInteractor()
    var tickets = [Ticket]()
    private lazy var errorPresenter = ErrorPresenter(baseVC: self)
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .foilRed
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchTickets()
    }
    
    private func configureTableView() {
        tableView.configureForFoil()
        tableView.refreshControl = refresher
    }
    
    private func fetchTickets() {
        ticketInteractor.fetchTickets(from: .tickets()) { (tickets, error) in
            if let error = error {
                print(error)
                self.errorPresenter.present(error: FoilLocalError.noConnection.error)
            } else {
                self.tickets = tickets
                DispatchQueue.main.async {
                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func refreshControlTriggered() {
        self.fetchTickets()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueNibCell(cellClass: FoilCell.self)
        cell.configure(with: tickets[indexPath.row])
        return cell
    }
}
