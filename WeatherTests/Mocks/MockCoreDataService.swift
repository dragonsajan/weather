//
//  MockCoreDataService.swift
//  WeatherTests
//
//  Created by Sajan Kushwaha on 2/6/26.
//

@testable import Weather

final class MockCoreDataService: CoreDataServiceProtocol {

    private(set) var saveCalled = false
    private(set) var deleteCalled = false

    var storedWeather: [WeatherData] = []

    func save(weather: WeatherData) {
        saveCalled = true
        storedWeather.append(weather)
    }

    func fetchAllWeatherData() -> [WeatherData] {
        storedWeather
    }

    func delete(weather: WeatherData) {
        deleteCalled = true
        storedWeather.removeAll { $0 == weather }
    }
}
