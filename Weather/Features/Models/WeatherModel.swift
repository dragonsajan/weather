//
//  WeatherModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

struct Weather: Identifiable {
    let id = UUID()
    let city: String
    let temperature: Double
    let condition: String
    let icon: String
}

