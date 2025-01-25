//
//  WeatherView.swift
//  helloworld
//
//  Created by Simon Sung on 1/20/25.
//

import SwiftUI

// DetailView is a custom view that displays an icon and label with a value (e.g., wind speed, temperature)
struct DetailView: View {
    var imageName: String    // Image name for system icon
    var name: String         // Label for the detail
    var value: String        // Value for the detail (e.g., wind speed value)

    var body: some View {
        HStack(spacing: 12) {
            // Icon representing the detail
            Image(systemName: imageName)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0, brightness: 0.4))
                .cornerRadius(50)
            
            // Text information about the detail
            VStack(alignment: .leading, spacing: 8) {
                Text(name)    // Label for the detail
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                Text(value)   // The actual value (e.g., "12 m/s" for wind speed)
                    .bold()
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

// SunView displays the sunrise and sunset times, and shows the percentage of daytime passed
struct SunView: View {

    @Binding var isShowing: Bool // Binding to control visibility of the view
    var weather: ResponseBody   // Weather data to show sunrise and sunset times
    var sunriseTime: String     // Sunrise time in local format
    var sunsetTime: String      // Sunset time in local format

    var body: some View {
        ZStack {
            if isShowing {
                VStack {
                    // Header with title and close button
                    HStack {
                        Spacer()
                        Text("Sunrise and Sunset")
                            .foregroundColor(.white)
                            .padding(.init(top: 5, leading: 30, bottom: 20, trailing: 0))
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 30, height: 29)
                            .onTapGesture {
                                isShowing = false // Close the view when tapped
                            }
                            .padding(.init(top: 5, leading: 0, bottom: 20, trailing: 0))
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    }
                    .padding()
                    
                    // Show the current local time
                    Text("Local Time: \(getCurrentDate())")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .padding(.top, -20)
                    
                    ZStack {
                        // A circular progress bar showing daytime percentage
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 8))
                            .rotationEffect(.degrees(-180))
                            .opacity(0.5)
                            .frame(width: 250)
                            .overlay(
                                Circle()
                                    .trim(from: 0, to: dayTime(sunrise: weather.sys.sunrise, sunset: weather.sys.sunset))
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.orange]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        style: StrokeStyle(lineWidth: 8)
                                    )
                                    .rotationEffect(.degrees(-180))
                            )
                        
                        // Sunrise and Sunset labels with icons
                        HStack(spacing: 180) {
                            VStack {
                                Image(systemName: "sunrise.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 50, height: 42)
                                Text("Sunrise")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(sunriseTime) // Display the sunrise time
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack {
                                Image(systemName: "sunset.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 50, height: 42)
                                Text("Sunset")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(sunsetTime) // Display the sunset time
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 0, y: 65)
                        
                        // Total daylight time label
                        VStack {
                            Text("Total daylight:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            Text(dayTimeCoverter(sunrise: weather.sys.sunrise, sunset: weather.sys.sunset)) // Convert the day time to readable format
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.bottom, 20)
                                .foregroundColor(.white)
                        }
                        .offset(x: 0, y: 45)
                    }
                    Spacer()
                }
            }
        }
    }
    
    // Calculate the percentage of the day that has passed
    func dayTime(sunrise: Double, sunset: Double) -> Double {
        let daytime = sunset - sunrise
        let currentDate = Date()
        
        let unixTimestamp = Int(currentDate.timeIntervalSince1970)
        let currentTimeDouble = Double(unixTimestamp)
        
        let currentTimeDifferent = currentTimeDouble - sunrise
        
        if currentTimeDifferent >= daytime {
            return 0 // No daytime left if it's after sunset
        } else {
            // Calculate the percentage of daytime passed
            let precentageDayTime = currentTimeDifferent / daytime
            return precentageDayTime / 2
        }
    }
    
    // Get the current time in the local time zone
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezone)
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    // Convert the sunrise and sunset times into a readable time format
    func dayTimeCoverter(sunrise: Double, sunset: Double) -> String {
        let dayTime = sunset - sunrise
        let hours = Int((dayTime / 3600).rounded())
        let minutes = (Int(dayTime) % 3600) / 60
        
        return "\(hours)HR \(minutes)MIN" // Format the result as hours and minutes
    }
}

// WeatherDetailsView shows detailed weather information like wind, temperature, and humidity
struct WeatherDetailsView: View {

    @Binding var isShowing: Bool // Binding to control visibility of the view
    var weather: ResponseBody   // Weather data to show details

    var body: some View {
        ZStack {
            if isShowing {
                VStack {
                    // Header with title and close button
                    HStack {
                        Spacer()
                        Text("Weather Details")
                            .foregroundColor(.white)
                            .padding(.init(top: 5, leading: 30, bottom: 0, trailing: 0))
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 30, height: 29)
                            .onTapGesture {
                                isShowing = false // Close the view when tapped
                            }
                            .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    }
                    .padding()
                    
                    // Wind section
                    HStack {
                        Image(systemName: "wind")
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 20, bottom: -5, trailing: 0))
                        Text("Wind")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                    }
                    VStack {
                        // Display wind speed and pressure
                        HStack(spacing: 40) {
                            DetailView(imageName: "wind", name: "Wind speed ", value: weather.wind.speed.roundDouble().description + " m/s")
                                .padding(.init(top: 20, leading: 6, bottom: 10, trailing: 0))
                            DetailView(imageName: "gauge.with.dots.needle.50percent", name: "Pressure       ", value: weather.main.pressure.roundDouble().description + " hPa")
                                .padding(.init(top: 20, leading: 10, bottom: 10, trailing: 2))
                        }
                        
                        // Display wind direction and humidity
                        HStack(spacing: 40) {
                            DetailView(imageName: degreeToDirectionImage(degree: weather.wind.deg), name: "Direction        ", value: degreeToDirection(degree: weather.wind.deg))
                                .padding(.init(top: 10, leading: 10, bottom: 20, trailing: 0))
                            DetailView(imageName: "humidity", name: "Humidity       ", value: weather.main.humidity.description + " %")
                                .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 10))
                        }
                    }
                    .padding()
                    .padding(.top, -20)
                    .padding(.bottom, -20)
                    
                    // Temperature section
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 20, bottom: -5, trailing: 0))
                        Text("Temperature")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                    }
                    VStack {
                        // Display max and min temperature
                        HStack(spacing: 40) {
                            DetailView(imageName: "thermometer.high", name: "Max temp     ", value: weather.main.tempMax.roundDouble().description + "°")
                                .padding(.init(top: 20, leading: 8, bottom: 10, trailing: 0))
                            DetailView(imageName: "thermometer.low", name: "Min temp      ", value: weather.main.tempMin.roundDouble().description +  "°")
                                .padding(.init(top: 20, leading: 4, bottom: 10, trailing: 10))
                        }
                    }
                    .padding()
                    .padding(.top, -20)
                    Spacer()
                }
            }
        }
    }
    
    // Convert wind direction in degrees to a human-readable string
    func degreeToDirection(degree: Double) -> String {
        let directions = ["E", "NE", "N", "NW", "W", "SW", "S", "SE","E"]
        let index = Int((degree / 45).rounded())
        return "\(degree)° \(directions[index])"
    }

    // Return an image name for the wind direction icon
    func degreeToDirectionImage(degree: Double) -> String {
        let directions = ["arrow.left", "arrow.down.left", "arrow.down", "arrow.down.right", "arrow.right", "arrow.up.right", "arrow.up", "arrow.up.left","arrow.left"]
        let index = Int((degree / 45).rounded())
        return directions[index]
    }
}
