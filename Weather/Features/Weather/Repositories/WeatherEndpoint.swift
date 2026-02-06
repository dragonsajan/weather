//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

enum WeatherEndpoint: ApiEndPoint {
    
    case usingLocation(latitude: Double, longitude: Double)

    var path: String {
        switch self {
            case .usingLocation:
                return "weather"
        }
    }
    
    var queryItems: [URLQueryItem]? {
            switch self {
            case .usingLocation(let latitude, let longitude):
                return [
                    URLQueryItem(name: "lat", value: "\(latitude)"),
                    URLQueryItem(name: "lon", value: "\(longitude)"),
                    URLQueryItem(name: "appid", value: AppSecrets.getValueFor(.weatherApiKey))
                ]
            }
        }
    
}

