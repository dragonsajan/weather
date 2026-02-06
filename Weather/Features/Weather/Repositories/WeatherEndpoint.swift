//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

enum WeatherEndpoint: ApiEndPoint {
    
    case usingLocation(latitude: Double, longitude: Double)
    case search(keyword: String)
    
    func getAppid() -> URLQueryItem { URLQueryItem(name: "appid", value: AppSecrets.getValueFor(.weatherApiKey)) }

    var path: String {
        switch self {
            case .usingLocation:
                return "/data/2.5/weather"
            case .search:
                return "/geo/1.0/direct"
        }
    }
    
    var queryItems: [URLQueryItem]? {
            switch self {
            case .usingLocation(let latitude, let longitude):
                return [
                    URLQueryItem(name: "lat", value: "\(latitude)"),
                    URLQueryItem(name: "lon", value: "\(longitude)"),
                    getAppid()
                ]
            case .search(let keyword):
                return [
                    URLQueryItem(name: "q", value: keyword),
                    URLQueryItem(name: "limit", value: "10"),
                    getAppid()
                ]
            }
        }
    
}

