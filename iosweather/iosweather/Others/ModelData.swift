//
//  ModelData.swift
//  helloworld
//
//  Created by Simon Sung on 1/21/25.
//

import Foundation

// Load weather data from the "weatherData.json" file and decode it into a ResponseBody object
var previewWeather: ResponseBody = load("weatherData.json")

// Generic function to load and decode a JSON file into a specified Decodable type
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    // Attempt to locate the file in the main bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            // If the file is not found, trigger a fatal error
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        // Attempt to load the data from the found file
        data = try Data(contentsOf: file)
    } catch {
        // If loading fails, trigger a fatal error with the specific error message
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        // Attempt to decode the data into the specified type
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        // If decoding fails, trigger a fatal error with the error message
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
