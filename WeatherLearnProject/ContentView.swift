//
//  ContentView.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 08.03.2025.
//

import SwiftUI

struct ContentView: View {
    
    let futureData: [Forecast] = [
        Forecast(day: "MO", icon: "sun.rain.fill", temperature: 20),
        Forecast(day: "TU", icon: "cloud.sun.fill", temperature: 21),
        Forecast(day: "WE", icon: "sun.max.fill", temperature: 22),
        Forecast(day: "TH", icon: "cloud.fill", temperature: 19),
        Forecast(day: "FR", icon: "cloud.rain.fill", temperature: 18)
    ]
    
    @State private var dark: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundGradient(isPresented: $dark) // -> Dollar zeigt, dass es ein State ist
            VStack {
                LaregeDayIcon(temperature: 24, icon: "cloud.sun.fill", location: "Wolfsburg, DE")
                DaysIconRow(weather_upcoming_days_array: futureData)
                Spacer()
                Button {
                    //dark.toggle()
                    withAnimation {dark.toggle()}
                    print("Dark is \(self.dark)")
                } label: {
                    RoundedRectangle(cornerRadius: 20).frame(width: .infinity, height: 50)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Toogle Dark").foregroundStyle(.black)
                        )
                }
                Spacer()
            }
            .padding([.top, .leading, .trailing])
        }
    }
}

#Preview {
    ContentView()
}

struct BackgroundGradient: View {
    
    @Binding var isPresented: Bool // -> Gibt an, dass dieses Binding von außen kommt
    
    var colors: [Color] {
        isPresented ? [.black, .gray] : [.blue, .white]
    } // -> Schreibt die Werte in colors abhängig von isPresented
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct DaysIconRow: View {
    
    let weather_upcoming_days_array: [Forecast]
    
    var body: some View {
        HStack(alignment: .center, spacing: 30.0){
            ForEach(weather_upcoming_days_array) {item in
                SmallWeatherIconView(day: item.day, icon: item.icon, temperature: item.temperature)
            }
        }
        .padding(.vertical)
    }
}

struct LaregeDayIcon: View {
    
    let temperature: Int
    let icon: String
    let location: String
    
    var body: some View {
        Text(location).font(.system(size:30))
            .multilineTextAlignment(.center).foregroundStyle(.white)
        Image(systemName: icon).renderingMode(.original).resizable().aspectRatio(contentMode: .fit).frame(width: 180, height: 180)
        Text("\(temperature)°C").font(.system(size: 50)).foregroundStyle(.white)
    }
}

struct Forecast: Identifiable {
    let id = UUID()          // optional, z. B. für SwiftUI-ForEach
    let day: String
    let icon: String
    let temperature: Int
}
