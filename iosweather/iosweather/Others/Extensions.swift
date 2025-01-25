//
//  Extensions.swift
//  helloworld
//
//  Created by Simon Sung on 1/21/25.
//

import Foundation

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}

extension TimeInterval{
    func timeStamp() -> String {
        
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
