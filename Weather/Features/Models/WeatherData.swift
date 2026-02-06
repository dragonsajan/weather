//
//  WeatherModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

struct WeatherData: Identifiable, Hashable {
    
    let id = UUID()
    let city: String
    let subtitle: String
    let condition: String
    let temperature: String
    let high: String
    let low: String
    let iconName: String
    
    // Conver the give icon name into full url to load in view
    var iconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(iconName).png")!
    }

    var temperatureValue: Double {
        Double(temperature.dropLast(2)) ?? 0.0
    }

    
    /// Initilize to make Weather data using api response class
    /// - Parameter response: WeatherResponse api response class
    init?(from response: WeatherResponse) {
        guard let name = response.name,
              let main = response.main,
              let weatherCondition = response.weather?.first else {
            return nil
        }

        
        let country        = response.sys?.country ?? "??"
        let feelsLikeStr   = Self.formatKelvin(main.feelsLike)
        let tempStr        = Self.formatKelvin(main.temp)
        let highStr        = Self.formatKelvin(main.tempMax)
        let lowStr         = Self.formatKelvin(main.tempMin)
        let conditionStr  = weatherCondition.main ?? "Unknown"
        let iconStr       = weatherCondition.icon ?? "questionmark"

        
        self.city        = name
        self.subtitle    = "\(country) • Feels like \(feelsLikeStr)"
        self.condition   = conditionStr
        self.temperature = tempStr
        self.high        = highStr
        self.low         = lowStr
        self.iconName    = iconStr
    }

    
    // FIXME: Later move the code in utility function and update the temperate value on basis of setting
    /// Private function to conver the data in degree for now
    /// - Parameter kelvin:
    /// - Returns: Degree String
    private static func formatKelvin(_ kelvin: Double?) -> String {
        guard let kelvin else { return "N/A" }
        let celsius = kelvin - 273.15
        return String(format: "%.0f°C", celsius)
    }
    
}

