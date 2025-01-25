//
//  WelcomeView.swift
//  helloworld
//
//  Created by Simon Sung on 1/25/25.
//

import SwiftUI
import CoreLocationUI // Import the CoreLocationUI to use location-related UI elements like LocationButton

// WelcomeView is the main view where the user is welcomed and prompted to share their location for weather data
struct WelcomeView: View {
    
    // The environment object to manage location updates
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            // Welcome section with a title and description text
            VStack(spacing: 20) {
                Text("Welcome to the Weather App")
                    .bold()  // Make the title bold
                    .font(.title)  // Set the font size to title
                    .foregroundColor(.white)  // Set the text color to white
                
                Text("Click the button to start sharing your location and get the weather forecast")
                    .padding()  // Add padding around the text for spacing
                    .foregroundColor(.white)  // Set the text color to white
            }
            .multilineTextAlignment(.center)  // Center align the text
            .padding()  // Add padding around the entire VStack
            
            // LocationButton that prompts the user to share their location
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()  // Request location when the button is clicked
            }
            .cornerRadius(30)  // Apply rounded corners to the button
            .symbolVariant(.fill)  // Use the filled symbol variant for the button
            .foregroundColor(.white)  // Set the button symbol color to white
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Make the entire view take up the full screen
    }
}


#Preview {
    WelcomeView()
}
