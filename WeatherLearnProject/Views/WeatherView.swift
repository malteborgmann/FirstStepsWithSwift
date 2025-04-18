//
//  ContentView.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 08.03.2025.
//

import SwiftUI


struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isDay: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundGradient(isPresented: $isDay) // -> Dollar zeigt, dass es ein State ist
            VStack {
                LaregeDayIcon(temperature: viewModel.currentTemperature, icon: viewModel.currentWeatherIcon, location: "Wolfsburg, DE")
                DaysIconRow(weather_upcoming_days_array: viewModel.forecasts)
                
                Spacer()
                
                Button {
                    //dark.toggle()
                    withAnimation {isDay.toggle()}
                    print("Dark is \(viewModel.isDay)")
                } label: {
                    RoundedRectangle(cornerRadius: 20).frame(width: .infinity, height: 50)
                        .foregroundColor(.white)
                        .overlay(
                            Text("Toogle Dark").foregroundStyle(.black)
                        )
                }
               
                
            }
            .padding([.top, .leading, .trailing])
        }
    }
}

#Preview {
    WeatherView()
}

struct BackgroundGradient: View {
    
    @Binding var isPresented: Bool // -> Gibt an, dass dieses Binding von außen kommt
    
    var colors: [Color] {
        isPresented ? [.blue, .white] :  [.black, .gray] 
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

