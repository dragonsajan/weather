//
//  WeatherRepositoryProtocol.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

protocol WeatherRepositoryProtocol {
    
    /// Fetch weather based on location latitude and longitude
    func fetchWeathForLocation(latitude: Double, longitude: Double) async -> Result<WeatherData, ApiError>
    
    /// Fetch city list based on search keywords
    func fetchCityList(keyword: String) async -> Result<[CityData], ApiError>
    
}
