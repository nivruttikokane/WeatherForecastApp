//
//  NetworkMonitor.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import Network

protocol NetworkMonitoring {
    var isConnected: Bool { get }
}


class NetworkMonitor: NetworkMonitoring {
    static let shared = NetworkMonitor()  // Singleton instance
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private(set) var isConnected: Bool = true  // Default to true
    
    private init() {}
    
}
