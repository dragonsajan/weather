//
//  WeatherHomeViewModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Combine
import SwiftUI

@MainActor
final class WeatherHomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let repository: WeatherRepositoryProtocol
    
    // MARK: - UI State
    @Published private(set) var weatherList: [WeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func delete(_ weather: WeatherData) {
        weatherList.removeAll { $0.id == weather.id }
    }
    
    
}

// MARK: - Api Calls
extension WeatherHomeViewModel {

    func fetchWeatherDataForLocation(latitude: Double = 44.34, longitude: Double = 10.99, force: Bool = false) async {

        // Check to stop paralle and duplicate call
        if fetchTask != nil && !force { return }

        fetchTask = Task {
            isLoading = true
            errorMessage = nil

            let result = await repository.fetchWeathForLocation(latitude: latitude, longitude: longitude)

            isLoading = false
            fetchTask = nil

            switch result {
            case .success(let response):
                weatherList = [response]

            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }

        await fetchTask?.value
    }
}
