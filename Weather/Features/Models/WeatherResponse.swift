//
//  WeatherResponse.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//


import Foundation

/// Map response using any online tool or link
///
/// It help to easily and faster create new model for response change. It won't impact app as there is always a mapper function for actual
/// model to be used in app

struct WeatherResponse: Codable {
    let coord: Coordinates?
    let weather: [WeatherCondition]?
    let main: MainWeather?
    let wind: Wind?
    let clouds: Clouds?
    let sys: SystemInfo?
    let name: String?
    let cod: Int?
}


struct Coordinates: Codable {
    let lon: Double?
    let lat: Double?
}

struct WeatherCondition: Codable {
    let main: String?
    let description: String?
    let icon: String?
}

struct MainWeather: Codable {
  
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
        case pressure
        case humidity
        case seaLevel  = "sea_level"
        case grndLevel = "grnd_level"
    }
    
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct SystemInfo: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
