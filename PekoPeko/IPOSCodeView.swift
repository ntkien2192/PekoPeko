//
//  IPOSCodeView.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 02/12/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import CoreLocation

class IPOSCodeView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var labelCardAddress: UILabel!
    
    let locationManager = CLLocationManager()
    var userLocation: Location? {
        didSet {
            if let cardID = cardID, let userLocation = userLocation {
                CardStore.getIPOSCode(cardID: cardID, location: userLocation, completionHandler: { (card, error) in
                    if let card = card {
                        if let code = card.code {
                            self.labelCardAddress.text = "\(code)"
                        }
                    }
                })
            }
        }
    }
    
    var cardID: String? {
        didSet {
            locationManager.startUpdatingLocation()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("IPOSCodeView", owner: self, options: nil)
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func buttonBackTapped(_ sender: Any) {
        weak var _self = self
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }) { _ in
            _self?.removeFromSuperview()
        }
    }
}

extension IPOSCodeView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations[0]
        userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
