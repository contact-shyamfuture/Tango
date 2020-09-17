//
//  LocationService.swift
//  Sihatku
//
//  Created by Shyam Future Tech on 03/03/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(location : CLLocationCoordinate2D)
}

class LocationService : NSObject,CLLocationManagerDelegate{
    
    static let SharedManager = LocationService()
    private var locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    
    var delegate : LocationUpdateProtocol!

    private override init () {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations[0].coordinate
        
        DispatchQueue.main.async {
            self.delegate.locationDidUpdateToLocation(location: self.currentLocation!)
        }
        
    }
    
}
