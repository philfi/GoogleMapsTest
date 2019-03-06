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

    private let toggleButton = UIButton()
    private var shouldShowCircles: Bool = false

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        toggleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        toggleButton.backgroundColor = .yellow
        toggleButton.setTitle("Tap", for: .normal)

        view.addSubview(toggleButton)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false

        toggleButton.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: 40.7020841, longitude: -74.0140688))
    }

    private let circle1Location = CLLocationCoordinate2D(latitude: 40.70208, longitude: -74.01406)

    @objc private func toggleButtonTapped(_: Any) {
//        shouldShowCircles = !shouldShowCircles
//        if shouldShowCircles {
//
//        } else {
            circles.forEach { $0.map = nil }
            circles.removeAll()

            let circle1 = GMSCircle(position: circle1Location, radius: 100)
            circle1.map = mapView
            circles.append(circle1)
//        }
    }


}

