//
//  WeatherHomeViewModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Combine
import SwiftUI

// Possible Navigation
enum WeatherHomeAction {
    case navigate(WeatherData)
    case delete(WeatherData)
}

@MainActor
final class WeatherHomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    fileprivate let repository: WeatherRepositoryProtocol
    fileprivate weak var coordinator: MainCoordinator?
    
    // MARK: - UI State
    @Published private(set) var weatherList: [WeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(repository: WeatherRepositoryProtocol, coordinator: MainCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
}

// MARK: - Navigations and Actions
extension WeatherHomeViewModel {
    
    func handle(_ action: WeatherHomeAction) {
        switch action {
        case .navigate(let data):
            coordinator?.push(.weatherDetail(data: data))

        case .delete(let data):
            weatherList.removeAll { $0.id == data.id }
        }
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
