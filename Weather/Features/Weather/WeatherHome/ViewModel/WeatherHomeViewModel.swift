//
//  WeatherHomeViewModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Combine
import SwiftUI
internal import _LocationEssentials

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
    @Published var showLocationPermissionAlert: Bool = false
    
    @Published var searchText: String = ""
    @Published var isSearchPresented: Bool = false
    
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(repository: WeatherRepositoryProtocol, coordinator: MainCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    
    func validateAndLoadWeather() {
        loadWeatherForCurrentLocation()
    }
    
}

// MARK: - Navigations and Actions
extension WeatherHomeViewModel {
    
    func openSearch() {
        isSearchPresented = true
    }
    
    
    func addWeather(_ data: WeatherData) {
        if !weatherList.contains(data) {
            weatherList.insert(data, at: 0)
        }
    }
    
    func addCity(_ city: CityData) async {
        let result = await repository.fetchWeathForLocation(
            latitude: city.latitude,
            longitude: city.longitude
        )

        if case .success(let weather) = result {
            weatherList.append(weather)
        }
    }

    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }

        UIApplication.shared.open(url)
    }
    
    
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
    
    fileprivate func loadWeatherForCurrentLocation() {
        isLoading = true
        errorMessage = nil

        LocationService.shared.getCurrentLocation { [weak self] result in
            guard let self else { return }

            Task { @MainActor in
                switch result {
                case .success(let coordinate):
                    await self.fetchWeatherDataForLocation(latitude: coordinate.latitude,
                                                           longitude: coordinate.longitude)

                case .failure(let error):
                    self.isLoading = false

                    if let locationError = error as? LocationError,
                       locationError == .permissionDenied {
                        self.errorMessage = locationError.localizedDescription
                        self.showLocationPermissionAlert = true
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    

    fileprivate func fetchWeatherDataForLocation(latitude: Double = 44.34, longitude: Double = 10.99, force: Bool = false) async {

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
