//
//  LocationManager.swift
//  YelpDemo
//
//  Created by rhalfer on 25/01/2021.
//

import SwiftUI

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject {
    
    @Published var lastLocation: CLLocation? {
        didSet {
            objectWillChange.send()
        }
    }
    var locationStatus: CLAuthorizationStatus?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }


    /*{
        willSet {
            let newLongitude = newValue?.coordinate.longitude ?? 0
            let newLatitude = newValue?.coordinate.latitude ?? 0
            let currentLongitude = lastLocation?.coordinate.longitude ?? 0
            let currentLatitude = lastLocation?.coordinate.latitude ?? 0
            if currentLatitude != newLatitude && currentLongitude != newLongitude {
               objectWillChange.send()
            }
        }
    }*/

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, location)
    }
}
