//
//  LocationService.swift
//  MiniApps
//
//  Created by Evelina on 03.09.2024.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func startLocation()
    func getUserCity(latitude: Double, longitude: Double) async -> String?
}

protocol LocationServiceDelegateProtocol: NSObject {
    func didUpdateLocation(_ location: CLLocation)
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    private var geocoder: CLGeocoder = CLGeocoder()
    weak var delegate: LocationServiceDelegateProtocol?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        delegate?.didUpdateLocation(userLocation)
    }
    
    func getUserCity(latitude: Double, longitude: Double) async -> String? {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            do {
                let placemark = try await geocoder.reverseGeocodeLocation(location).first
                return (placemark?.locality ?? "") /*+ ", " + (placemark?.country ?? "")*/
            } catch {
                
            }
            return nil
        }
    
    func startLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}
