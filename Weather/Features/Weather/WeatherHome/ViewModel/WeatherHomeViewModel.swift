//
//  WeatherHomeViewModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Combine


class WeatherHomeViewModel: ObservableObject {
    
    @Published var weatherList: [Weather] = [
            Weather(
                city: "Edison",
                temperature: 22,
                condition: "Partly Cloudy",
                icon: "cloud.sun.fill"
            ),
            Weather(
                city: "New York",
                temperature: 18,
                condition: "Rain",
                icon: "cloud.rain.fill"
            ),
            Weather(
                city: "Metachuen",
                temperature: 30,
                condition: "Sunny",
                icon: "sun.max.fill"
            )
        ]
}
