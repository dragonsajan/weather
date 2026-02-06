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

final class WeatherHomeViewModel: ObservableObject {

    // MARK: - Dependencies
    fileprivate let repository: WeatherRepositoryProtocol
    fileprivate weak var coordinator: (any Coordinator)?
    fileprivate let coreData: CoreDataServiceProtocol
    fileprivate let locationService: LocationServiceProtocol

    // MARK: - UI State
    @Published private(set) var weatherList: [WeatherData] = []
    
    private var isInitialLoad = false

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showLocationPermissionAlert: Bool = false
    
    // For opening search view
    @Published var isSearchPresented: Bool = false
    
    var hasLoadedOnce: Bool = false

    // MARK: - Init
    init(
            repository: WeatherRepositoryProtocol,
            coordinator: (any Coordinator)?,
            coreData: CoreDataServiceProtocol,
            locationService: LocationServiceProtocol
        ) {
            self.repository = repository
            self.coordinator = coordinator
            self.coreData = coreData
            self.locationService = locationService
        }

    /// View data starts from here
    ///
    /// Main Func  is`refreshAllWeather` :  Refresh is common point, where it takes all the data from db and
    /// Update data by api call as well as update (UI watching List )
    ///
    /// So normally catch is, we add the data to db if required and then start the `refreshAllWeather` function
    ///
    /// There are 3 scanarios
    ///
    /// 1 & 2. When the app starts:
    /// It will check flag `isInitialLoad`
    /// 1.1 if `isInitialLoad` = true, then will just start the common update flow `refreshAllWeather`
    /// where it will get all the data in db and fetch and update the ui view
    ///
    /// else will (`isInitialLoad` = false)
    /// 2.1 get current location and create WeatherData Object
    /// 2.2 then will add to db and start common update flow `refreshAllWeather` which will update and show all data
    ///
    /// 3. When app user serch and add new city
    /// 3.1 Once user select city from the search, it will create weather object form city object
    /// 3.2 then will add to db and start common update flow `refreshAllWeather` which will update and show all data
    ///
    ///
    /// after that it will refresh the
    func validateAndLoadWeather() {
        if hasLoadedOnce {
            Task { await refreshAllWeather() }
        } else {
            getCurrentLocationWeather()
            hasLoadedOnce = true
        }
    }
}


// MARK: - Navigations and Actions
extension WeatherHomeViewModel {
    
    /// When user tap on search, it opens the search view
    func openSearch() {
        isSearchPresented = true
    }

    /// When user selects data from city search view
    ///
    /// It will create WeatherData from CityData and Save to db
    /// later on
    /// `refreshAllWeather` :  Refresh is common point, where it takes all the data from db and
    /// Update data by api call as well as update (UI watching List )
    func addCity(_ city: CityData) async {
        let weatherData = WeatherData(city: city)
        self.coreData.save(weather: weatherData)
        await self.refreshAllWeather()
    }

    /// When permisson is denied for location but need to promt user to turn on from setting
    func openAppSettings() {
        Utility.openAppSettings()
    }

    /// For navigation and delete actions
    func handle(_ action: WeatherHomeAction) {
        switch action {
        case .navigate(let data):
            coordinator?.push(.weatherDetail(data: data))

        case .delete(let data):
            removeWeather(data)
        }
    }
}


// MARK: - Main Functions
extension WeatherHomeViewModel {
    
    /// This function takes current location and add to db so that when db refresh new data is added to list (UI watching List )
    /// then start the `refreshAllWeather`
    ///
    /// `refreshAllWeather` :  Refresh is common point, where it takes all the data from db and
    /// Update data by api call as well as update (UI watching List )
    private func getCurrentLocationWeather() {
        isLoading = true
        errorMessage = nil
        
        self.locationService.getCurrentLocation { [weak self] result in
            guard let self else { return }
            
            Task {
                switch result {
                case .success(let coordinate):
                    // Save the data in db and start the refresh process
                    // Refresh is common point, where it takes all the data from db and
                    // Update data by api call as well as update (UI watching List )
                    let weatherData = WeatherData(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    self.coreData.save(weather: weatherData)
                    await self.refreshAllWeather()
                    
                case .failure(let error):
                    await MainActor.run {
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
    }

    /// refreshAllWeather: This the main Function
    ///
    /// It takes all the data in db
    /// run api call in paralle and later update all the data in (UI watching List )
    func refreshAllWeather() async {
        
        let weatherList = self.coreData.fetchAllWeatherData()
        
        let results: [WeatherData] = await withTaskGroup(
            of: WeatherData?.self,
            returning: [WeatherData].self
        ) { group in

            for weather in weatherList {
                group.addTask {
                    await self.fetchWeather(
                        latitude: weather.latitude,
                        longitude: weather.longitude
                    )
                }
            }

            var collected: [WeatherData] = []
            for await result in group {
                if let weather = result {
                    collected.append(weather)
                }
            }
            return collected
        }

        // MainActor : As Only here the watch property is updated
        await MainActor.run {
            for weather in results {
                self.addOrUpdate(weather)
            }
            self.isLoading = false
        }
    }
}



// MARK: - Weather List Helpers
extension WeatherHomeViewModel {

    /// Just add / update in weatherList which is used to render on UI
    func addOrUpdate(_ weather: WeatherData) {
        if let index = weatherList.firstIndex(of: weather) {
            weatherList[index] = weather
        } else {
            weatherList.append(weather)
        }
    }
    
    /// Remove from List and then from database form background thread
    func removeWeather(_ weather: WeatherData) {

        weatherList.removeAll { $0 == weather }

        // Delete from CoreData in background
        Task.detached(priority: .background) {
            await CoreDataService.shared.delete(weather: weather)
        }
    }
}


// MARK: - Just fetch data from server
extension WeatherHomeViewModel {

    fileprivate func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async -> WeatherData? {

        let result = await repository.fetchWeatherForLocation(
            latitude: latitude,
            longitude: longitude
        )

        switch result {
        case .success(let weatherData):
            return weatherData

        case .failure(let error):
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
