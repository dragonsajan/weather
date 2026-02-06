//
//  WeatherModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

struct WeatherData: Identifiable, Hashable {
    
    let id: UUID
    let city: String
    let subtitle: String
    let condition: String
    let temperature: String
    let high: String
    let low: String
    let iconName: String
    let latitude: Double
    let longitude: Double
    
    // Conver the give icon name into full url to load in view
    var iconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(iconName).png")!
    }

    var temperatureValue: Double {
        Double(temperature.dropLast(2)) ?? 0.0
    }
    
    // Alternate initilizer
    // MARK: - Init from CoreData (placeholder)
        init(from entity: CDWeather) {
            self.id = LocationID.from(latitude: entity.latitude, longitude: entity.longitude)
            self.city = entity.city ?? "—"
            self.subtitle = entity.subtitle ?? "—"
            self.condition = "—"
            self.temperature = "—"
            self.high = "—"
            self.low = "—"
            self.iconName = entity.iconName ?? "questionmark"
            self.latitude = entity.latitude
            self.longitude = entity.longitude
        }
    
    // Alternate initilizer
        init(latitude: Double, longitude: Double) {
            self.id = LocationID.from(latitude: latitude, longitude: longitude)
            self.city = "—"
            self.subtitle = "—"
            self.condition = "—"
            self.temperature = "—"
            self.high = "—"
            self.low = "—"
            self.iconName = "questionmark"
            self.latitude = latitude
            self.longitude = longitude
        }
    
    init(city: CityData) {
        self.id = LocationID.from(latitude: city.latitude, longitude: city.longitude)
        self.city = "-"
        self.subtitle = "—"
        self.condition = "—"
        self.temperature = "—"
        self.high = "—"
        self.low = "—"
        self.iconName = "questionmark"
        self.latitude = city.latitude
        self.longitude = city.longitude
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
        let lat           = response.coord?.lat ?? 0.0
        let long          = response.coord?.lon ?? 0.0

        self.id          = LocationID.from(latitude: lat, longitude: long)
        self.city        = name
        self.subtitle    = "\(country) • Feels like \(feelsLikeStr)"
        self.condition   = conditionStr
        self.temperature = tempStr
        self.high        = highStr
        self.low         = lowStr
        self.iconName    = iconStr
        self.latitude    = lat
        self.longitude   = long
        
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


