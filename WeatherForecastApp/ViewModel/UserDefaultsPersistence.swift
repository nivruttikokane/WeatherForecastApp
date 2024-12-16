//
//  UserDefaultsPersistence.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import Foundation

protocol PersistenceProtocol {
    func saveLastSearchedCity(_ city: String)
    func getLastSearchedCity() -> String?
    func saveWeatherResponse(_ response: WeatherResponse)
    func getWeatherResponse() -> WeatherResponse?
}

class UserDefaultsPersistence: PersistenceProtocol {
    private let lastCityKey = "LastSearchedCity"
    private let weatherResponseKey = "WeatherResponse"
    
    func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: lastCityKey)
    }
    
    func getLastSearchedCity() -> String? {
        UserDefaults.standard.string(forKey: lastCityKey)
    }
    
    func saveWeatherResponse(_ response: WeatherResponse) {
        if let data = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(data, forKey: weatherResponseKey)
        }
    }
    
    func getWeatherResponse() -> WeatherResponse? {
        guard let data = UserDefaults.standard.data(forKey: weatherResponseKey) else { return nil }
        return try? JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
