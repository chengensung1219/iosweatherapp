//
//  LocationManager.swift
//  helloworld
//
//  Created by Simon Sung on 1/25/25.
//

import Foundation
import CoreLocation

// LocationManager class to handle location updates and manage CLLocationManager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // CLLocationManager instance to handle location services
    let manager = CLLocationManager()
    
    // Published property to store the current location coordinates
    @Published var location: CLLocationCoordinate2D?
    
    // Published property to track loading state (whether location is being fetched)
    @Published var isLoading = false
    
    override init() {
        super.init()
        
        // Set the delegate to handle CLLocationManager events
        manager.delegate = self
        
        // Set the desired accuracy for location updates
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request authorization to access location services when the app is in use
        manager.requestWhenInUseAuthorization()
        
        // Start updating the location when the LocationManager is initialized
        manager.startUpdatingLocation()
    }
    
    // Request a one-time location update
    func requestLocation(){
        isLoading = true
        manager.requestLocation() // Request the current location
    }
    
    // Refresh the location by stopping and restarting location updates
    func refreshLocation() {
        isLoading = true
        
        // Stop current location updates
        manager.stopUpdatingLocation()
        
        // Restart location updates after a small delay (0.5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.manager.startUpdatingLocation()
        }
    }
    
    // Delegate method called when location updates successfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the location property with the first coordinate from the updated locations
        location = locations.first?.coordinate
        
        // Set loading state to false once the location is fetched
        isLoading = false
    }
    
    // Delegate method called when location request fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Print the error if location fetch fails
        print("Error getting location", error)
        
        // Set loading state to false if there is an error
        isLoading = false
    }
}
