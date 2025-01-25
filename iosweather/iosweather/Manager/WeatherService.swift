//
//  WeatherService.swift
//  helloworld
//
//  Created by Simon Sung on 1/21/25.
//

import Foundation
import CoreLocation

// API key for accessing the OpenWeather API
var apiKey = "1cd4c8327559c581ac7a777757c4de90"

class WeatherService {
    // Function to fetch the current weather for a given latitude and longitude
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        // Construct the URL for the OpenWeather API with latitude, longitude, and API key
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric") else {
            fatalError("Missing URL") // Fatal error if the URL is invalid
        }
        
        // Create a URLRequest with the constructed URL
        let urlRequest = URLRequest(url: url)
        
        // Perform the network request and await the result (data and response)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check if the response's status code is 200 (successful)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching weather data") // Fatal error if status code is not 200
        }
        
        // Decode the received data into a ResponseBody object
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        // Return the decoded weather data
        return decodedData
    }
}

// Struct to represent the response data from the OpenWeather API
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse // Coordinates (latitude and longitude)
    var weather: [WeatherResponse] // Weather details (like main weather type, description)
    var main: MainResponse // Main weather data (temperature, pressure, humidity)
    var name: String // City name
    var wind: WindResponse // Wind details
    var sys: SunResponse // Sunrise and sunset times
    var timezone: Int // Timezone offset in seconds

    // Struct to represent coordinates
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    // Struct to represent weather information
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    // Struct to represent main weather data
    struct MainResponse: Decodable {
        var temp: Double // Temperature
        var feels_like: Double // Temperature as it feels
        var temp_min: Double // Minimum temperature
        var temp_max: Double // Maximum temperature
        var pressure: Double // Atmospheric pressure
        var humidity: Double // Humidity percentage
    }
    
    // Struct to represent wind data
    struct WindResponse: Decodable {
        var speed: Double // Wind speed
        var deg: Double // Wind direction in degrees
    }
    
    // Struct to represent sun data (sunrise and sunset)
    struct SunResponse: Decodable {
        var sunrise: Double // Sunrise time (Unix timestamp)
        var sunset: Double // Sunset time (Unix timestamp)
    }
}

// Extension to map the MainResponse properties to more user-friendly names
extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
