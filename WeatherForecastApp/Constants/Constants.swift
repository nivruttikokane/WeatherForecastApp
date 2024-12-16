//
//  Constants.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

struct Constants{
    static let baseURL = "https://api.openweathermap.org/data/2.5/forecast/daily"
    static let apiKey = "c5628af44b342c1a69f2148db6511362"
    
    //Error
    static let Nointernetconnection = "Network Error: No internet connection."
    static let requesttimedout = "Network Error: The request timed out."
    static let Unabletoconnecttotheserver = "Network Error: Unable to connect to the server."
    static let Pleasecheckthecityname = "Failed to fetch weather. Please check the city name."
    

}
