//
//  ContentView.swift
//  helloworld
//
//  Created by Simon Sung on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherService()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack{
            if let location = locationManager.location {
                if let weather = weather {
                    MainView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather data: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.98))
        .preferredColorScheme(.dark)
    }
}


#Preview {
    ContentView()
}
