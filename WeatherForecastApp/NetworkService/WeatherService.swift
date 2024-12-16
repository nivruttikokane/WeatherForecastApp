//
//  WeatherService.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error>
}

class WeatherService: WeatherServiceProtocol {
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(Constants.baseURL)?q=\(city)&cnt=5&appid=\(Constants.apiKey)&units=metric"
        print(urlString)
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
