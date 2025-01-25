//
//  LocationManager.swift
//  helloworld
//
//  Created by Simon Sung on 1/25/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func requestLocation(){
        isLoading = true
        manager.requestLocation()
    }
    
    func refreshLocation() {
        isLoading = true
        manager.stopUpdatingLocation() // Stop the current updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Small delay to reset updates
            self.manager.startUpdatingLocation() // Restart updates
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
}
