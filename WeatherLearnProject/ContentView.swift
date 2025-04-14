//
//  ContentView.swift
//  WeatherLearnProject
//
//  Created by Malte Borgmann on 08.03.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var i: Int = 1
    @State private var dark: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundGradient(isPresented: $dark) // -> Dollar zeigt, dass es ein State ist
            VStack {
                
                LaregeDayIcon(temperature: 24, icon: "cloud.sun.fill", location: "Wolfsburg, DE")
                DaysIconRow()
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
    var body: some View {
        // TODO: Get Icon Name and Temperature from Array
        HStack(alignment: .center, spacing: 30.0){
            SmallWeatherIconView(day: "MO", icon: "sun.rain.fill", temperature: "20")
            SmallWeatherIconView(day: "DI", icon: "sun.rain.fill", temperature: "20")
            SmallWeatherIconView(day: "MI", icon: "sun.rain.fill", temperature: "20")
            SmallWeatherIconView(day: "DO", icon: "sun.rain.fill", temperature: "20")
            SmallWeatherIconView(day: "FR", icon: "sun.rain.fill", temperature: "20")
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
