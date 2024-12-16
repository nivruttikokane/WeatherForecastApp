//
//  MockWeatherService.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import XCTest
import Combine
@testable import WeatherForecastApp

class MockWeatherService: WeatherServiceProtocol {
    var mockResponse: WeatherResponse?  // Holds the mocked success response
    var error: Error?  // Holds the mocked error for failure cases

    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let response = mockResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher() // Default failure
        }
    }

}



class MockPersistenceService: PersistenceProtocol {
    private var lastSearchedCity: String?
    private var weatherResponse: WeatherResponse?

    func saveLastSearchedCity(_ city: String) {
        lastSearchedCity = city
    }

    func getLastSearchedCity() -> String? {
        return lastSearchedCity
    }

    func saveWeatherResponse(_ response: WeatherResponse) {
        weatherResponse = response
    }

    func getWeatherResponse() -> WeatherResponse? {
        return weatherResponse
    }
}
