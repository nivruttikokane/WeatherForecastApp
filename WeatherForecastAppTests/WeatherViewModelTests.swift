//
//  WeatherViewModelTests.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import XCTest
import Combine
@testable import WeatherForecastApp

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var mockPersistenceService: MockPersistenceService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        mockWeatherService = MockWeatherService()
        mockPersistenceService = MockPersistenceService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService, persistenceService: mockPersistenceService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        mockPersistenceService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch weather succeeds")
        let mockResponse = WeatherResponse(
            list: [
                DailyForecast(dt: 1678928400, temp: Temperature(min: 10, max: 20), weather: [Weather(main: "Cloudy", description: "Cloudy", icon: "02d")], humidity: 22),
                DailyForecast(dt: 1679014800, temp: Temperature(min: 12, max: 22), weather: [Weather(main: "Sunny", description: "Clear sky", icon: "01d")], humidity: 22)
            ],
            city: City(name: "Test City")
        )
        mockWeatherService.mockResponse = mockResponse  // Set mockResponse
        
        // Act
        viewModel.fetchWeather(for: "Test City")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.cityName, "Test City")
            XCTAssertEqual(self.viewModel.forecasts.count, 2)
            XCTAssertEqual(self.viewModel.forecasts[0].weather[0].main, "Cloudy")
            XCTAssertEqual(self.viewModel.forecasts[1].weather[0].main, "Sunny")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    
    func testFetchWeatherFailure() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch weather fails")
        mockWeatherService.error = URLError(.badServerResponse)  // Simulate server error
        
        // Act
        viewModel.fetchWeather(for: "Test City")
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.errorMessage, "Network Error: Unable to connect to the server.") // Updated expected message
            XCTAssertTrue(self.viewModel.forecasts.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    
    func testSaveLastSearchedCity() {
        // Arrange
        let testCity = "Saved City"
        
        // Act
        viewModel.fetchWeather(for: testCity)
        
        // Assert
        XCTAssertEqual(mockPersistenceService.getLastSearchedCity(), testCity)
    }
    
    func testRetrieveLastSearchedCityOnInit() {
        // Arrange
        let savedCity = "Previously Searched City"
        mockPersistenceService.saveLastSearchedCity(savedCity)
        
        // Act
        let newViewModel = WeatherViewModel(
            weatherService: mockWeatherService,
            persistenceService: mockPersistenceService
        )
        
        // Assert
        XCTAssertEqual(newViewModel.persistenceService.getLastSearchedCity(), savedCity)
    }
    
    func testFetchWeatherFromLastSavedResponse() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch weather from saved response succeeds")
        let savedResponse = WeatherResponse(
            list: [
                DailyForecast(dt: 1678928400, temp: Temperature(min: 15, max: 25), weather: [Weather(main: "Sunny", description: "Clear sky", icon: "01d")], humidity: 22)
            ],
            city: City(name: "Test City")
        )
        mockPersistenceService.saveWeatherResponse(savedResponse)
        
        // Act
        if let response = mockPersistenceService.getWeatherResponse() {
            viewModel.cityName = response.city.name
            viewModel.forecasts = response.list
        }
        
        // Assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.cityName, "Test City")
            XCTAssertEqual(self.viewModel.forecasts.count, 1)
            XCTAssertEqual(self.viewModel.forecasts[0].weather[0].main, "Sunny")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testFetchWeatherNoInternet() {
        let mockWeatherService = MockWeatherService()
        let mockPersistenceService = MockPersistenceService()
        let mockNetworkMonitor = MockNetworkMonitor(isConnected: false)  // Simulate no internet
        let viewModel = WeatherViewModel(
            weatherService: mockWeatherService,
            persistenceService: mockPersistenceService,
            networkMonitor: mockNetworkMonitor  // Pass mock monitor
        )
        let expectation = XCTestExpectation(description: "Fetch fails due to no internet")
        
        viewModel.fetchWeather(for: "Test City")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.errorMessage, "No internet connection. Please check your network and try again.")
            XCTAssertTrue(viewModel.forecasts.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
