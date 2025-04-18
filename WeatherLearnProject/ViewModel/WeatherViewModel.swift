//
//  WeatherViewModel.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 18.04.25.
//


import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    
    @Published var forecasts: [Forecast] = []
    @Published var currentWeatherIcon: String = "questionmark"
    @Published var currentTemperature: Int = 0
    @Published var isDay: Bool = true
    
    
    private let latitude: Double
    private let longitude: Double
    

    
    // Dynamisch generierte URL
    var urlString: String {
        return "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weather_code,temperature_2m_mean&current=temperature_2m,weather_code,is_day"
    }
    
    
    // Initializer mit Standardwerten für Berlin (52.52, 13.41)
    init(latitude: Double = 52.52, longitude: Double = 13.41) {
        self.latitude = latitude
        self.longitude = longitude
        fetchWeather()
    }
    
    func fetchWeather() {
        guard let url = URL(string: urlString) else {
            print("URL not found")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No Data")
                return
            }
            
            do {
                // JSON manuell in Dictionary parsen
                let raw = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                print(raw)
                
                // MARK: Aktuelles Wetter separat decodieren
                if let currentRaw = raw?["current"] {
                    let currentData = try JSONSerialization.data(withJSONObject: currentRaw)
                    let current = try JSONDecoder().decode(CurrentWeather.self, from: currentData)
                    
                    // Schreiben in die Instanzvariablen
                    DispatchQueue.main.async {
                        self.currentTemperature = Int(current.temperature)
                        self.currentWeatherIcon = weatherCodeToIcon[current.weatherCode] ?? "questionmark"
                        self.isDay = (current.isDay != 0)
                    }
                }
                
                // MARK: Tagesvorhersage separat decodieren
                if let dailyRaw = raw?["daily"] {
                    let dailyData = try JSONSerialization.data(withJSONObject: dailyRaw)
                    let daily = try JSONDecoder().decode(DailyData.self, from: dailyData)
                    
                    let forecastList = zip(zip(daily.time, daily.temperature), daily.weatherCode)
                        .prefix(5)
                        .map { tuple in
                            let ((dateString, temp), code) = tuple
                            let icon = weatherCodeToIcon[code] ?? "questionmark.circle.fill"
                            let day = Self.getDayOfWeek(from: dateString) ?? "?"
                            return Forecast(day: day, icon: icon, temperature: Int(temp))
                        }
                    
                    DispatchQueue.main.async {
                        self.forecasts = forecastList
                    }
                }
                
                
                
            } catch {
                print("Cant parse data: \(error)")
            }
        }.resume()
    }
    
    static func getDayOfWeek(from dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return nil }
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEE" // "Mon", "Tue", etc.
        return formatter.string(from: date).uppercased()
    }
}


struct DailyData: Codable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case temperature = "temperature_2m_mean"
        case weatherCode = "weather_code"
    }
}

struct CurrentWeather: Codable {
    let temperature: Double
    let weatherCode: Int
    let isDay: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case isDay = "is_day"
    }
}

// https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=weather_code,temperature_2m_mean&current=temperature_2m,weather_code,is_day


let weatherCodeToIcon: [Int: String] = [
    // Clear
    0: "sun.max.fill",
    
    // Mainly clear, partly cloudy, and overcast
    1: "cloud.sun.fill",
    2: "cloud.fill",
    3: "smoke.fill",
    
    // Fog and rime fog
    45: "cloud.fog.fill",
    48: "cloud.fog",
    
    // Drizzle
    51: "cloud.drizzle",
    53: "cloud.drizzle.fill",
    55: "cloud.heavyrain.fill",
    
    // Freezing Drizzle
    56: "snowflake",
    57: "snowflake.circle.fill",
    
    // Rain
    61: "cloud.rain",
    63: "cloud.rain.fill",
    65: "cloud.heavyrain.fill",
    
    // Freezing Rain
    66: "cloud.sleet",
    67: "cloud.sleet.fill",
    
    // Snow fall
    71: "cloud.snow",
    73: "cloud.snow.fill",
    75: "snowflake.circle",
    
    // Snow grains
    77: "snowflake",
    
    // Rain showers
    80: "cloud.sun.rain.fill",
    81: "cloud.rain.circle",
    82: "cloud.heavyrain.circle.fill",
    
    // Snow showers
    85: "cloud.snow",
    86: "cloud.snow.fill",
    
    // Thunderstorm
    95: "cloud.bolt.fill",
    96: "cloud.bolt.rain.fill",
    99: "cloud.bolt.rain.circle.fill"
]
