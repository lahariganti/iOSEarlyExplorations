//
//  AirportsVC.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/2/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit

class FlightScheduleVC: UIViewController {
    let fromAirportCode: String
    let toAirportCode: String
    let fromDate: Date

    var accessToken: AccessToken?
    let tokenInteractor = TokenInteractor()
    let scheduleInteractor = ScheduleInteractor()
    lazy var spinnerPresenter = SpinnerPresenter(hasDimView: true, spinnerStyle: .whiteLarge)
    private lazy var errorPresenter = ErrorPresenter(baseVC: self)

    let tableView = UITableView()
    private let reuseIdentifier = "AirportCell"

    var schedules = [Schedule]()
    var flights = [Flight]()

    init(fromAirportCode: String, toAirportCode: String, fromDate: Date) {
        self.fromAirportCode = fromAirportCode
        self.toAirportCode = toAirportCode
        self.fromDate = fromDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureTableView()
        fetchAccessToken { (success) in
            if success {
                self.fetchSchedules()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = UIScreen.main.bounds
    }

    private func configureSelf() {
        title = "Flights"
        spinnerPresenter.parentVC = self
        spinnerPresenter.addSpinner()
        view.addSubview(tableView)
    }

    private func configureTableView() {
        tableView.register(AirportCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func presentError(with localError: NSError) {
        DispatchQueue.main.async {
            self.spinnerPresenter.removeSpinner()
            self.errorPresenter.present(error: localError)
        }
    }

    private func fetchAccessToken(completion: @escaping (_ success: Bool) -> Void) {
        tokenInteractor.fetchAccessToken(.accessToken()) { (accessToken, error) in
            if let error = error {
                print(error.localizedDescription)
                self.presentError(with: ZeusLocalError.generic.error)
                completion(false)
            }

            if let accessToken = accessToken {
                self.accessToken = accessToken
                completion(true)
            }
        }
    }


    private func fetchSchedules() {
        guard let token = accessToken?.accessToken else { return }
        scheduleInteractor.fetchSchedule(token, .schedules(origin: fromAirportCode, destination: toAirportCode, fromDateTime: fromDate)) { (scheduleResource, error) in
            if let error = error {
                print(error.localizedDescription)
                self.presentError(with: ZeusLocalError.generic.error)
                return
            }

            if let schedules = scheduleResource?.scheduleResource?.schedule {
                self.schedules = schedules
                DispatchQueue.main.async {
                    self.spinnerPresenter.removeSpinner()
                    self.tableView.reloadData()
                }
            } else {
                self.presentError(with: ZeusLocalError.notfound.error)
            }
        }
    }

}

extension FlightScheduleVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! AirportCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: schedules[indexPath.row])
        return cell
    }
}

extension FlightScheduleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let flight = schedules[indexPath.row].flight?.first else { return }
        if let departureCode = flight.departure?.airportCode, let arrivalCode = flight.arrival?.airportCode, let token = accessToken?.accessToken {
            let vc = MapVC(originAirportCode: departureCode, destinationAirportCode: arrivalCode, accessToken: token)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

