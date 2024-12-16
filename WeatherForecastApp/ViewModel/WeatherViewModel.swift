//
//  WeatherViewModel.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import Foundation
import Combine


class WeatherViewModel: ObservableObject {
    @Published var forecasts: [DailyForecast] = []
    @Published var cityName: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false  // Loading state
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    private let networkMonitor: NetworkMonitoring
    let persistenceService: PersistenceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService(),persistenceService: PersistenceProtocol, networkMonitor:NetworkMonitoring = NetworkMonitor.shared) {
        self.weatherService = weatherService
        self.persistenceService = persistenceService
        self.networkMonitor = networkMonitor
        
        // Load saved weather data and city
        if let savedCity = persistenceService.getLastSearchedCity() {
            self.cityName = savedCity
        }
        if let savedResponse = persistenceService.getWeatherResponse() {
            self.forecasts = savedResponse.list
            self.cityName = savedResponse.city.name
        }
    }
    
    func fetchWeather(for city: String) {
        guard networkMonitor.isConnected else {  // Use the instance variable
            self.errorMessage = "No internet connection. Please check your network and try again."
            return
        }
        
        persistenceService.saveLastSearchedCity(city) // Save city name
        isLoading = true  // Show activity indicator
        errorMessage = nil
        forecasts = []  // Clear previous data
        weatherService.fetchWeather(for: city)
            .sink { [weak self] completion in
                self?.isLoading = false  // Hide activity indicator
                switch completion {
                case .failure(let error):
                    self?.errorMessage = self?.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { response in
                self.cityName = response.city.name
                self.forecasts = response.list
                self.persistenceService.saveWeatherResponse(response) // Save response
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return Constants.Nointernetconnection
            case .timedOut:
                return Constants.requesttimedout
            case .badServerResponse:
                return Constants.Unabletoconnecttotheserver
            default:
                return "Network Error: \(urlError.localizedDescription)"
            }
        } else {
            return Constants.Pleasecheckthecityname
        }
    }
    
}
