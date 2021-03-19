//
//  RootVC.swift
//  isItColdOutside
//
//  Created by Lahari Ganti on 1/31/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import UnsplasherSDK
import SDWebImage


class RootVC: UIViewController {
    let locationManager = CLLocationManager()
    let weatherObject = Weather()
    var unitChanged: Bool = false
    var temperature: JSON = [:]
    let searchClient = Unsplash.shared.search

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var shouldIBringAJAcketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Is It Cold Outside"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))

        for label in [cityNameLabel, weatherDescriptionLabel, temperatureLabel] {
            label?.textColor = .white
            label?.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            label?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            label?.layer.cornerRadius = 8
            label?.clipsToBounds = true
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        shouldIBringAJAcketButton.layer.cornerRadius = 8
        shouldIBringAJAcketButton.clipsToBounds = true
        shouldIBringAJAcketButton.addTarget(self, action: #selector(shouldIBringAJAcketButtonPressed), for: .touchUpInside)

        self.backgroundImageView.backgroundColor = .dodgerBlue
    }

    @objc func searchButtonPressed() {
        let switchVC = SwitchVC()
        switchVC.delegate = self
        present(switchVC, animated: true, completion: nil)
    }

    @objc func refreshButtonTapped() {
        locationManager.startUpdatingLocation()
    }

    @objc func shouldIBringAJAcketButtonPressed() {

    }

    func setTemperature(temperature: Double) {
        if unitChanged == false {
            weatherObject.temperature = Int(temperature - 273.15)
        } else {
            weatherObject.temperature = Int((temperature - 273.15) * 9/5 + 32)
        }
    }

    func updateUIWithWeatherData() {
        cityNameLabel.text = weatherObject.city
        weatherDescriptionLabel.text = weatherObject.weatherDescription
        temperatureLabel.text = "\(weatherObject.temperature) ºC"
        searchWeatherImage(weatherDescription: weatherObject.weatherDescription)
    }

    func updateWeatherData(json: JSON) {
        temperature = json["main"]["temp"]
        let city = json["name"]
        let condition = json["weather"][0]["id"]
        let weatherDescription = json["weather"][0]["description"]
        if let temperatureValue = temperature.double {
            setTemperature(temperature: temperatureValue)
            weatherObject.city = city.stringValue
            weatherObject.condition = condition.intValue
            weatherObject.weatherDescription = weatherDescription.stringValue
            updateUIWithWeatherData()
        } else {
            cityNameLabel.text = "NA"
        }
    }

    func getWeatherData(url: String, parameters: [String: Any ]) {
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                self.cityNameLabel.text = "Connection issues"
            }
        }

    }

    func searchWeatherImage(weatherDescription: String) {
//        let splitWords = weatherDescription.components(separatedBy: " ")
        searchClient?.photos(query: weatherDescription, page: 1, perPage: 20, orientation: .portrait, completion: { (result) in
            if let photos = result.value?.photos {
                if let randomPhoto = photos.randomElement() {
                    if let url = randomPhoto.urls {
                            UIView.transition(with: self.backgroundImageView,
                                              duration: 0.3,
                                              options: .curveEaseIn,
                                              animations: {self.backgroundImageView.sd_setImage(with: url.raw)},
                                              completion: nil)
                    }
                }
            }
        })
    }
}


extension RootVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let location = location {
            print(location)
            if location.horizontalAccuracy > 0.0 {
                locationManager.stopUpdatingLocation()
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                let params = ["lat": latitude, "lon": longitude, "appid": APP_ID] as [String: Any]

                getWeatherData(url: WEATHER_URL, parameters: params)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityNameLabel.text = "Location NA"
    }
}

extension RootVC: SwitchDelegate {
    func userEneteredANewCityName(city: String) {
        let params = ["q": city, "appid": APP_ID] as [String: Any]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
}
