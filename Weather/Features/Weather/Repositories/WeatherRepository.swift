//
//  WeatherRepository.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private let apiService: ApiServiceProtocol
    
    // ApiServiceProtocol: Use Protocol Dependency injection for future moking and testing
    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchWeatherForLocation(latitude: Double, longitude: Double) async -> Result<WeatherData, ApiError> {
        let endPoint = WeatherEndpoint.usingLocation(latitude: latitude, longitude: longitude)
        let response: Result<WeatherResponse, ApiError> = await apiService.request(endPoint)

        switch response {
        case .success(let response):
            guard let weatherData = WeatherData(from: response) else {
                return .failure(.decodingData("Failed to map WeatherResponse to CityWeather"))
            }
            return .success(weatherData)

        case .failure(let error):
            return .failure(error)
        }
    }
    
    
    func fetchCityList(keyword: String) async -> Result<[CityData], ApiError> {

        let endpoint = WeatherEndpoint.search(keyword: keyword)
        let response: Result<[CityResponse], ApiError> =
            await apiService.request(endpoint)

        switch response {

        case .success(let cityResponses):
            let cityList = CityData.map(from: cityResponses)

            // Empty result is VALID for search
            return .success(cityList)

        case .failure(let error):
            return .failure(error)
        }
    }
    
}

