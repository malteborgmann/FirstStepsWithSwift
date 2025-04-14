//
//  SmallWeatherIconView.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 08.03.2025.
//

import SwiftUI

struct SmallWeatherIconView: View {
    
    
    let day: String
    let icon: String
    let temperature: String
    
    var body: some View {
        VStack {
            Text(day)
                .font(.caption).foregroundStyle(.white)
            Image(systemName: icon).renderingMode(.original)
                .font(.system(size: 32))
            Text("\(temperature)°C").font(.caption).foregroundStyle(.white)
        }
        
    }
}

#Preview {
    SmallWeatherIconView(day: "MO", icon: "sun.rain.fill", temperature: "20")
}
