//
//  AnotherViewController.swift
//  GoogleMapsTest
//
//  Created by Philip Hubert on 4/16/19.
//  Copyright © 2019 Philip Hubert. All rights reserved.
//

import UIKit

protocol AnotherViewControllerDelegate: AnyObject {
    func anotherViewControllerDidRequestDismiss(_: AnotherViewController)
}

class AnotherViewController: UIViewController {
    weak var delegate: AnotherViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissButton = UIButton()
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(.black, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)

        view.addSubview(dismissButton)
        dismissButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
    }

    @objc private func dismissButtonTapped(_: Any) {
        delegate?.anotherViewControllerDidRequestDismiss(self)
    }
}
