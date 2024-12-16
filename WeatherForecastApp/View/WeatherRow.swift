//
//  WeatherRow.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import SwiftUI

// Row to display a single day's weather forecast
struct WeatherRow: View {
    let forecast: DailyForecast
    
    var body: some View {
        HStack {
            Text(forecast.dt.toDayOfWeek())
                .frame(width: 80, alignment: .leading)
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.weather.first?.icon ?? "")@2x.png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(forecast.weather.first?.main ?? "")
                    .font(.headline)
                Text("Min:\(forecast.temp.min, specifier: "%.1f")°C / Max:\(forecast.temp.max, specifier: "%.1f")°C")
                    .font(.subheadline)
                Text("Humidity :\(forecast.humidity)").font(.subheadline)
                
            }
        }
    }
}

 
 

