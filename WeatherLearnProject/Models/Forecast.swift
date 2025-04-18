//
//  Forecast.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 18.04.25.
//

import Foundation

struct Forecast: Identifiable {
    let id = UUID()          // optional, z. B. für SwiftUI-ForEach
    let day: String
    let icon: String
    let temperature: Int
}
