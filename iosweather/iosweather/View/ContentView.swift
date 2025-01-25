//
//  ContentView.swift
//  helloworld
//
//  Created by Simon Sung on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    // LocationManager to manage the user's location
    @StateObject var locationManager = LocationManager()
    
    // WeatherService to fetch weather data based on location
    var weatherManager = WeatherService()
    
    // State variable to store the fetched weather data
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            // Check if the location has been successfully fetched
            if let location = locationManager.location {
                
                // If weather data is available, show the main view with weather data
                if let weather = weather {
                    MainView(weather: weather)
                } else {
                    // If weather data is not available, show a loading view while fetching
                    LoadingView()
                        .task {
                            // Fetch weather data using the location
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                // Print an error if weather data fetching fails
                                print("Error getting weather data: \(error)")
                            }
                        }
                }
            } else {
                // If location is not available yet, check loading state
                if locationManager.isLoading {
                    // Show loading view while fetching location
                    LoadingView()
                } else {
                    // If location is not loading, show a welcome view to ask for permission
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        // Set the background color to a dark shade with opacity
        .background(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.98))
        // Set the preferred color scheme to dark mode
        .preferredColorScheme(.dark)
    }
}



#Preview {
    ContentView()
}
