//
//  WeatherView.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel : WeatherViewModel
    @State private var city: String = ""
    
    init() {
        // Initialize the viewModel with WeatherService and UserDefaultsPersistence
        _viewModel = StateObject(wrappedValue: WeatherViewModel(
            weatherService: WeatherService(),
            persistenceService: UserDefaultsPersistence()
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let savedCity = viewModel.persistenceService.getLastSearchedCity(), city.isEmpty {
                    // Prefilled with the last searched city, showing dark text
                    TextField(savedCity, text: $city)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black) // Dark color when prefilled
                } else {
                    // New city input or empty state
                    TextField("Enter city", text: $city)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(city.isEmpty ? .gray : .black) // Light gray when empty, black otherwise
                }
                Button("Fetch Weather") {
                    viewModel.fetchWeather(for: city)
                }
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView("Loading Weather...")
                        .padding()
                }
                
                // Error Messagene
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // List of Weather Data
                if !viewModel.forecasts.isEmpty {
                    List(viewModel.forecasts, id: \.dt) { forecast in
                        WeatherRow(forecast: forecast)
                    }
                } else if !viewModel.isLoading && viewModel.errorMessage == nil {
                    // Show message when no data is available and there's no error
                    Text("No data available. Please search for a city.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle(viewModel.cityName.isEmpty ? "Weather Forecast" : viewModel.cityName)
            
        }
        .onAppear {
            if let lastCity = viewModel.persistenceService.getLastSearchedCity() {
                city = lastCity
            }
        }
    }
}

extension Int {
    func toDayOfWeek() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
