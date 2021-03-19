//
//  MapVC.swift
//  Zeus
//
//  Created by Lahari Ganti on 8/5/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    let mapView = MKMapView()
    let airportInteractor = AirportInteractor()
    lazy var spinnerPresenter = SpinnerPresenter(hasDimView: true, spinnerStyle: .whiteLarge)
    private lazy var errorPresenter = ErrorPresenter(baseVC: self)

    var originAirportCode: String
    var destinationAirportCode: String
    let accessToken: String

    var originAirport: Airport?
    var destinationAirport: Airport?

    init(originAirportCode: String, destinationAirportCode: String, accessToken: String) {
        self.originAirportCode = originAirportCode
        self.destinationAirportCode = destinationAirportCode
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        fetchAirportsData { (success) in
            if success {
                if
                    let originLatitude = self.originAirport?.position?.coordinate?.latitude,
                    let originLongitude = self.originAirport?.position?.coordinate?.longitude,
                    let destinationLatitude = self.destinationAirport?.position?.coordinate?.latitude,
                    let destinationLongitude = self.destinationAirport?.position?.coordinate?.longitude
                {
                    DispatchQueue.main.async {
                        self.showRouteOnMap(originAirportCoordinate: CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude), destinationAirportCoordinate: CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude))
                    }
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = UIScreen.main.bounds
    }

    private func configureSelf() {
        title = "\(originAirportCode) ➔ \(destinationAirportCode)"
        spinnerPresenter.parentVC = self
        spinnerPresenter.addSpinner()
        view.addSubview(mapView)
        mapView.delegate = self
    }

    private func presentError(with localError: NSError) {
        DispatchQueue.main.async {
            self.spinnerPresenter.removeSpinner()
            self.errorPresenter.present(error: localError)
        }
    }


    private func fetchAirportsData(completion: @escaping (_ success: Bool) -> Void) {
        var res: Bool = false

        airportInteractor.fetchOriginDestinationAirports(accessToken, [.airport(with: originAirportCode), .airport(with: destinationAirportCode)]) { (airportResources, error) in
            if let error = error {
                print(error.localizedDescription)
                self.presentError(with: ZeusLocalError.generic.error)
                completion(false)
            }

            if let originAirportResource = airportResources.first,
                let originAirport = originAirportResource?.airportResource?.airports?.airport {
                self.originAirport = originAirport
                res = true
            }

            if let destinationAirportResource = airportResources.last,
                let destinationAirport = destinationAirportResource?.airportResource?.airports?.airport {
                self.destinationAirport = destinationAirport
                completion(res)
            }
        }
    }
    
    private func showRouteOnMap(originAirportCoordinate: CLLocationCoordinate2D, destinationAirportCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: originAirportCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationAirportCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let originAnnotation = MKPointAnnotation()

        if let location = sourcePlacemark.location {
            originAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([originAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        directions.calculate { (response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                self.presentError(with: ZeusLocalError.directionsNotAvailable.error)
            }

            if let response = response {
                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .zeusDark
        renderer.lineWidth = 5.0
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.tintColor = .zeusLight
        return annotationView
    }
}
