//
//  WeatherView.swift
//  helloworld
//
//  Created by Simon Sung on 1/20/25.
//

import SwiftUI

struct DetailView: View {
    var imageName: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0, brightness: 0.4))
                .cornerRadius(50)
            VStack(alignment: .leading, spacing: 8){
                Text(name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                Text(value)
                    .bold()
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct SunView: View {
    
    @Binding var isShowing: Bool
    
    var weather: ResponseBody
    
    var sunriseTime: String
    var sunsetTime: String
    
    var body: some View {
        ZStack {
            if isShowing {
                VStack{
                    HStack{
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
                                isShowing = false
                            }
                            .padding(.init(top: 5, leading: 0, bottom: 20, trailing: 0))
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    }
                    .padding()
                    
                    Text("Local Time: \(getCureentDate())")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .padding(.top, -20)
                    
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 8))
                            .rotationEffect(.degrees(-180))
                            .opacity(0.5)
                            .frame (width: 250)
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
                                    .rotationEffect(.degrees(-180)))
                        
                        HStack(spacing: 180) {
                            VStack {
                                Image(systemName: "sunrise.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 50, height: 50)
                                Text("Sunrise")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(sunriseTime)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack {
                                Image(systemName: "sunset.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .frame(width: 50, height: 50)
                                Text("Sunset")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(sunsetTime)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 0, y: 65)
                        VStack{
                            Text("Total daylight:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            Text(dayTimeCoverter(sunrise: weather.sys.sunrise, sunset: weather.sys.sunset))
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
    func dayTime(sunrise: Double, sunset: Double) -> Double {
        let daytime = sunset - sunrise
        let currentDate = Date()
        
        let unixTimestamp = Int(currentDate.timeIntervalSince1970)
        let currentTimeDouble = Double(unixTimestamp)
        
        let currentTimeDifferent = currentTimeDouble - sunrise
        
        if currentTimeDifferent >= daytime {
            
            return 0
            
        } else {
            
            let precentageDayTime = currentTimeDifferent / daytime
            
            return precentageDayTime / 2
        }
    }
    func getCureentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezone)
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    func dayTimeCoverter(sunrise: Double, sunset: Double) -> String {
        
        let dayTime = sunset - sunrise
        let hours = Int((dayTime / 3600).rounded())
        let minutes = (Int(dayTime) % 3600) / 60
        
        return "\(hours)HR \(minutes)MIN"
    }
}

struct WeatherDetailsView: View {

    @Binding var isShowing: Bool
    
    var weather: ResponseBody
    
    var body: some View {
        ZStack {
            if isShowing {
                VStack{
                    HStack{
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
                                isShowing = false
                            }
                            .padding(.init(top: 5, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                    }
                    .padding()
                    
                    HStack{
                        Image(systemName: "wind")
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 20, bottom: -5, trailing: 0))
                        Text("Wind")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                    }
                    VStack{
                        HStack(spacing: 40){
                            DetailView(imageName: "wind", name: "Wind speed ", value: weather.wind.speed.roundDouble().description + " m/s")
                            
                                .padding(.init(top: 20, leading: 6, bottom: 10, trailing: 0))
                            DetailView(imageName: "gauge.with.dots.needle.50percent", name: "Pressure       ", value: weather.main.pressure.roundDouble().description + " hPa")
                               
                                .padding(.init(top: 20, leading: 10, bottom: 10, trailing: 2))
                            
                        }
                        
                        HStack(spacing: 40){
                            DetailView(imageName: degreeToDirectionImage(degree: weather.wind.deg), name: "Direction        ", value: degreeToDirection(degree: weather.wind.deg))
                            
                                .padding(.init(top: 10, leading: 10, bottom: 20, trailing: 0))
                            
                            DetailView(imageName: "humidity", name: "Humidity       ", value: weather.main.humidity.description + " %")
                                .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 10))
                        }
                    }
                    .padding()
                    .padding(.top, -20)
                    .padding(.bottom, -20)
                    
                    HStack{
                        Image(systemName: "thermometer")
                            .foregroundColor(.white)
                            .padding(.init(top: 0, leading: 20, bottom: -5, trailing: 0))
                        Text("Temperature")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.init(top: 0, leading: 0, bottom: -5, trailing: 0))
                    }
                    VStack{
                        HStack(spacing: 40){
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
    func degreeToDirection(degree: Double) -> String {
        
        let directions = ["E", "NE", "N", "NW", "W", "SW", "S", "SE","E"]
        
        let index = Int((degree / 45).rounded())
        let direction = "\(degree)° \(directions[index])"
        return direction
    }
    func degreeToDirectionImage(degree: Double) -> String {
        
        let directions = ["arrow.left", "arrow.down.left", "arrow.down", "arrow.down.right", "arrow.right", "arrow.up.right", "arrow.up", "arrow.up.left","arrow.left"]
        
        let index = Int((degree / 45).rounded())
        
        return directions[index]
    }
}
