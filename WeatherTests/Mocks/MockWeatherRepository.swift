//
//  MockWeatherRepository.swift
//  WeatherTests
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import Foundation
@testable import Weather

//final class MockWeatherRepository: WeatherRepositoryProtocol {
//
//    // MARK: - Configurable Results
//    var weatherResult: Result<WeatherData, ApiError> = .failure(.noData)
//    var cityListResult: Result<[CityData], ApiError> = .success([])
//
//    // MARK: - Tracking Calls (Assertions)
//    private(set) var fetchWeatherCalled = false
//    private(set) var fetchCityListCalled = false
//
//    private(set) var lastLatitude: Double?
//    private(set) var lastLongitude: Double?
//    private(set) var lastKeyword: String?
//
//    // MARK: - Protocol Methods
//
//    func fetchWeatherForLocation(
//        latitude: Double,
//        longitude: Double
//    ) async -> Result<WeatherData, ApiError> {
//
//        fetchWeatherCalled = true
//        lastLatitude = latitude
//        lastLongitude = longitude
//        return weatherResult
//    }
//
//    func fetchCityList(
//        keyword: String
//    ) async -> Result<[CityData], ApiError> {
//
//        fetchCityListCalled = true
//        lastKeyword = keyword
//        return cityListResult
//    }
//}


final class MockWeatherRepository: WeatherRepositoryProtocol {

    // Queue of results (one per API call)
    var weatherResultsQueue: [Result<WeatherData, ApiError>] = []

    // Single-result fallback (used in other tests)
    var weatherResult: Result<WeatherData, ApiError>?

    private(set) var fetchCalledCount = 0

    func fetchWeatherForLocation(
        latitude: Double,
        longitude: Double
    ) async -> Result<WeatherData, ApiError> {

        fetchCalledCount += 1

        // Use queued responses first
        if !weatherResultsQueue.isEmpty {
            return weatherResultsQueue.removeFirst()
        }

        // Fallback to single response
        if let weatherResult {
            return weatherResult
        }

        return .failure(.noData)
    }

    func fetchCityList(keyword: String) async -> Result<[CityData], ApiError> {
        return .success([])
    }
}
