//
//  MockNetworkMonitor.swift
//  WeatherForecastApp
//
//  Created by Nivrutti Kokane on 16/12/24.
//

import XCTest
import Combine
@testable import WeatherForecastApp

class MockNetworkMonitor: NetworkMonitoring {
    var isConnected: Bool

    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}


