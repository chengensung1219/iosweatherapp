//
//  Extensions.swift
//  helloworld
//
//  Created by Simon Sung on 1/21/25.
//

import Foundation

// Extension for Double to round the value to the nearest integer and return it as a string
extension Double {
    func roundDouble() -> String {
        // Rounds the value and formats it as a string with no decimal places
        return String(format: "%.0f", self)
    }
}

// Extension for TimeInterval (which represents a time in seconds) to format it as a timestamp
extension TimeInterval {
    func timeStamp() -> String {
        // Convert TimeInterval to total seconds
        let totalSeconds = Int(self)
        
        // Calculate the minutes and seconds from the total seconds
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        // Format the time as MM:SS
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

