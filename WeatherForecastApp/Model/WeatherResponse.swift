//
//  WeatherResponse.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import Foundation

struct WeatherResponse: Codable {
    let list: [DailyForecast]
    let city: City
}

struct DailyForecast: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
    var localIconPath: String?  // Path to saved weather icon
    let humidity: Int
    
    private enum CodingKeys: String, CodingKey {
            case dt, temp, weather, localIconPath, humidity
    }
}

struct Temperature: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct City: Codable {
    let name: String
}
