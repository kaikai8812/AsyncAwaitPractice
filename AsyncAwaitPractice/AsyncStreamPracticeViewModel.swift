//
//  AsyncStreamPractice.swift
//  AsyncAwaitPractice
//
//  Created by 青山凱 on 2024/03/14.
//

import Foundation
import CoreLocation

@MainActor
final class LocationManager: NSObject, ObservableObject {
    
    @Published
    var coordinate: CLLocationCoordinate2D = .init()
    
    private let locationManager = CLLocationManager()
    
    func setup() {
            locationManager.delegate = self

            switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    break
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    print("ダメでしたorz")
                @unknown default:
                    break
            }
        }
    
    func request() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startLocation() {
            locationManager.startUpdatingLocation()
        }
    
    func stopLocation() {
            locationManager.stopUpdatingHeading()
        }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        coordinate = lastLocation.coordinate
    }
}
