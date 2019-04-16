//
//  ViewController.swift
//  GoogleMapsTest
//
//  Created by Philip Hubert on 3/6/19.
//  Copyright © 2019 Philip Hubert. All rights reserved.
//

import GoogleMaps
import UIKit

class ViewController: UIViewController {
    private let mapView = GMSMapView()
    private var circles: [GMSCircle] = []

    private let presentButton = UIButton()
    private var shouldShowCircles: Bool = false

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        presentButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        presentButton.backgroundColor = .yellow
        presentButton.setTitle("Present", for: .normal)
        presentButton.setTitleColor(.black, for: .normal)

        view.addSubview(presentButton)
        presentButton.translatesAutoresizingMaskIntoConstraints = false

        presentButton.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.animate(with: GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: 40.7020841, longitude: -74.0140688), zoom: 13))

        uncertaintyCircleOffsetCounter = 0
        uncertaintyCircleAnimationTimer?.invalidate()
        uncertaintyCircleAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            self.plotUncertaintyCircle()
            self.uncertaintyCircleOffsetCounter += 5
        }
    }

    private let circle1Location = CLLocationCoordinate2D(latitude: 40.70208, longitude: -74.01406)
    private let circle2Location = CLLocationCoordinate2D(latitude: 40.7, longitude: -74.01406)

    private var uncertaintyCircleMarkers: [GMSCircle] = []
    private func addCircleMarkers(at coordinate: CLLocationCoordinate2D, radius: Double, percentOffset: Double) {
        removeUncertaintyCircle()

        let circleCoordinates = coordinate.circleCoordinates(
            radius,
            degreesBetweenPoints: calculateOptimalDegreesBetweenPointsForRadius(radius),
            percentOffset: percentOffset
        )

        circleCoordinates.forEach {
            let circleMarker = GMSCircle(position: $0, radius: 10)
            circleMarker.fillColor = .white
            circleMarker.map = mapView
            uncertaintyCircleMarkers.append(circleMarker)
        }
    }

    private func calculateOptimalDegreesBetweenPointsForRadius(_ radius: Double) -> Double {
        switch radius {
        case 0 ..< 200:
            return 30
        case 200 ..< 400:
            return 20
        case 400 ..< 600:
            return 15
        case 600 ..< 900:
            return 10
        case 900 ..< 1200:
            return 5
        default:
            return 1
        }
    }

    private func removeUncertaintyCircle() {
        uncertaintyCircleMarkers.forEach { $0.map = nil }
        uncertaintyCircleMarkers.removeAll()
    }

    private var uncertaintyCircleOffsetCounter = 0
    private var uncertaintyCircleAnimationTimer: Timer?

    private func plotUncertaintyCircle() {
        addCircleMarkers(at: circle1Location, radius: 100, percentOffset: Double(uncertaintyCircleOffsetCounter) / 100.0)
    }

    @objc private func toggleButtonTapped(_: Any) {
        presentButton.isUserInteractionEnabled = false
        let anotherViewController = AnotherViewController()
        anotherViewController.delegate = self
        present(anotherViewController, animated: true, completion: nil)
    }
}

extension CLLocationCoordinate2D {
    func circleCoordinates(_ meterRadius: Double, degreesBetweenPoints: Double = 1.0, percentOffset: Double = 0.0) -> [CLLocationCoordinate2D] {
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        var coordinates = [CLLocationCoordinate2D]()

        for index in 0 ... Int(numberOfPoints) {
            let degrees: Double = (Double(index) + percentOffset) * Double(degreesBetweenPoints)
            coordinates.append(project(distanceMeters: meterRadius, degrees: degrees))
        }
        return coordinates
    }

    func project(distanceMeters: Double, degrees: Double) -> CLLocationCoordinate2D {
        let distanceRadians: Double = distanceMeters / 6_371_000.0
        let centerLatRadians: Double = latitude * Double.pi / 180
        let centerLonRadians: Double = longitude * Double.pi / 180

        let degreeRadians: Double = degrees * Double.pi / 180
        let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distanceRadians) + cos(centerLatRadians) * sin(distanceRadians) * cos(degreeRadians))
        let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distanceRadians) * cos(centerLatRadians), cos(distanceRadians) - sin(centerLatRadians) * sin(pointLatRadians))
        let pointLat: Double = pointLatRadians * 180 / Double.pi
        let pointLon: Double = pointLonRadians * 180 / Double.pi
        return CLLocationCoordinate2DMake(pointLat, pointLon)
    }
}

extension ViewController: AnotherViewControllerDelegate {
    func anotherViewControllerDidRequestDismiss(_ anotherViewController: AnotherViewController) {
        anotherViewController.dismiss(animated: true, completion: nil)
        presentButton.isUserInteractionEnabled = true
    }
}
