//
//  MainView.swift
//  helloworld
//
//  Created by Simon Sung on 1/25/25.
//

import SwiftUI

struct MainView: View {
    
    // State object to manage the user's location
    @EnvironmentObject var locationManager: LocationManager
    
    // State variables to control the visibility of different views
    @State var showSunView = false
    @State var showWeatherDetail = false
    
    // Weather data passed into the view
    var weather: ResponseBody
    
    var body: some View {
        VStack {
            // Display location and weather information
            VStack {
                HStack {
                    Spacer()
                    HStack(alignment: .center){
                        // Location icon and name display
                        Image(systemName: "mappin")
                            .resizable()
                            .frame(width: 8, height: 20)
                            .foregroundColor(.white)
                        Text(weather.name)
                            .bold()
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding([.leading, .trailing])
                
                // Weather information display
                VStack{
                    // Main weather condition
                    Text(weather.weather[0].main)
                        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .font(.system(size: 18, weight: .bold))
                        .padding(.top, 10)
                    
                    HStack(spacing: 30){
                        // Temperature display
                        Text(weather.main.temp.roundDouble().description + "°")
                            .foregroundColor(.white)
                            .font(.system(size: 90, weight: .semibold).width(.compressed))
                            .padding(.top, -15)
                        
                        // Weather icon
                        Image(systemName: getWeatherIcon(name: weather.weather[0].main))
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 105, height: 70)
                            .padding(.top, -10)
                    }
                    .padding(.leading, 18)
                    .padding(.bottom, -5)
                    
                    // Weather description
                    Text(weather.weather[0].description.capitalized)
                        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity)
                .background(
                    // Background gradient for weather section
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.8, blue: 0.9, opacity: 1.0), Color(red: 0.5, green: 0.2, blue: 0.7, opacity: 0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(30)
                .padding(.top, -10)
                .padding()
                
                // Sunrise and Sunset info
                VStack{
                    HStack{
                        Image(systemName: "sun.horizon")
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 15, bottom: -5, trailing: -5))
                        Text("Sunrise & Sunset")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                        Button(action: {showSunView = true}){
                            Text("View More")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 18))
                        }
                    }
                    
                    // Sunrise and sunset icons and times
                    HStack{
                        VStack {
                            Image(systemName: "sunrise.fill")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 50, height: 42)
                            Text(convertTimestamp(weather.sys.sunrise))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                        
                        // Divider between sunrise and sunset
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 100, height: 4)
                            .foregroundColor(.white)
                            .padding(.horizontal, -10)
                        
                        VStack {
                            Image(systemName: "sunset.fill")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 50, height: 42)
                            Text(convertTimestamp(weather.sys.sunset))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.init(top: 20, leading: 0, bottom: 20, trailing: 0))
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(red: 0.155, green: 0.155, blue: 0.155, opacity: 1))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                    .padding()
                    .padding(.bottom, -15)
                    .onTapGesture {
                        showSunView = true
                    }
                }
            }
            
            // Weather details section
            VStack{
                HStack{
                    Image(systemName: "smoke")
                        .foregroundColor(.white)
                        .padding(.init(top: 12, leading: 16, bottom: 16, trailing: -3))
                    Text("Weather Details")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.init(top: 12, leading: 0, bottom: 15, trailing: 0))
                    Button(action: {showWeatherDetail = true}){
                        Text("View More")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.init(top: 12, leading: 0, bottom: 15, trailing: 18))
                    }
                }
                VStack{
                    // Weather detail rows (feel like, pressure, etc.)
                    HStack(spacing: -10){
                        DetailView(imageName: "thermometer", name: "Feel like    ", value: weather.main.feels_like.roundDouble().description + "°")
                        
                            .padding(.init(top: 20, leading: 10, bottom: 10, trailing: 0))
                            .frame(maxWidth: .infinity)
                        
                        DetailView(imageName: "gauge.with.dots.needle.50percent", name: "Pressure     ", value: weather.main.pressure.roundDouble().description + " hPa")
                            .padding(.init(top: 20, leading: 0, bottom: 10, trailing: 10))
                            .frame(maxWidth: .infinity)
                    }
                    
                    HStack(spacing: -10){
                        DetailView(imageName: "humidity", name: "Humidity   ", value: weather.main.humidity.description + " %")
                        
                            .padding(.init(top: 10, leading: 10, bottom: 20, trailing: 0))
                            .frame(maxWidth: .infinity)
                        
                        DetailView(imageName: "wind", name: "Wind speed   ", value: weather.wind.speed.roundDouble().description + " m/s")
                            .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 10))
                            .frame(maxWidth: .infinity)
                    }
                }
                .background(Color(red: 0.155, green: 0.155, blue: 0.155, opacity: 1))
                .frame(maxWidth: .infinity)
                .cornerRadius(30)
                .padding()
                .padding(.top, -20)
                .onTapGesture {
                    showWeatherDetail = true
                }
            }
            
            // External link button to Google Weather search
            Button(action: {
                if let url = URL(string: "https://www.google.com/search?q=weather") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "cloud.sun.fill")
                        .renderingMode(.original)
                    
                    Text("Check Weather on Google")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
            }
            .padding(.top, 10)
            Spacer()
                // Sheets to show detailed views for Sunrise/Sunset and Weather Details
                .sheet(isPresented: $showSunView){
                    SunView(isShowing: $showSunView, weather: weather, sunriseTime: convertTimestamp(weather.sys.sunrise), sunsetTime: convertTimestamp(weather.sys.sunset))
                        .presentationCornerRadius(30)
                        .presentationDetents([.fraction(0.5)])
                        .presentationBackground(Color(red: 0.155, green: 0.155, blue: 0.155, opacity: 1))
                }
                .sheet(isPresented: $showWeatherDetail){
                    WeatherDetailsView(isShowing: $showWeatherDetail, weather: weather)
                        .presentationCornerRadius(30)
                        .presentationDetents([.fraction(0.5)])
                        .presentationBackground(Color(red: 0.155, green: 0.155, blue: 0.155, opacity: 1))
                }
        }
    }
    
    // Function to convert timestamp to readable time format
    func convertTimestamp(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezone)
        return dateFormatter.string(from: date)
    }
    
    // Function to return corresponding weather icon based on condition
    func getWeatherIcon(name: String) -> String {
        switch name {
        case "Clouds":
            return "cloud.sun.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Clear":
            return "sun.horizon.fill"
        case "Drizzle":
            return "cloud.drizzle.fill"
        case "Thunderstorm":
            return "cloud.bolt.rain.fill"
        case "Snow":
            return "cloud.snow.fill"
        default:
            return "sun.fill"
        }
    }
}


#Preview {
    MainView(weather: previewWeather)
}
