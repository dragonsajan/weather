//
//  WeatherHomeViewModelTests.swift
//  WeatherTests
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import XCTest
import CoreLocation
@testable import Weather

@MainActor
final class WeatherHomeViewModelTests: XCTestCase {

    private var viewModel: WeatherHomeViewModel!

    private var mockRepository: MockWeatherRepository!
    private var mockCoreData: MockCoreDataService!
    private var mockLocation: MockLocationService!
    private var mockCoordinator: MockCoordinator!

    override func setUp() {
        super.setUp()

        mockRepository = MockWeatherRepository()
        mockCoreData = MockCoreDataService()
        mockLocation = MockLocationService()
        mockCoordinator = MockCoordinator()

        viewModel = WeatherHomeViewModel(
            repository: mockRepository,
            coordinator: mockCoordinator,
            coreData: mockCoreData,
            locationService: mockLocation
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func test_validateAndLoadWeather_firstLaunch_usesLocation() async {
        // Arrange
        let coordinate = CLLocationCoordinate2D(
            latitude: 27.7172,
            longitude: 85.3240
        )

        mockLocation.result = .success(coordinate)

        let apiWeather = WeatherData(
            latitude: 27.7172,
            longitude: 85.3240
        )

        mockRepository.weatherResult = .success(apiWeather)

        // Act
        viewModel.validateAndLoadWeather()
        try? await Task.sleep(nanoseconds: 300_000_000)

        // Assert
        XCTAssertTrue(mockLocation.getCurrentLocationCalled)
        XCTAssertTrue(mockCoreData.saveCalled)
        XCTAssertEqual(viewModel.weatherList.count, 1)
    }
    
    
    func test_validateAndLoadWeather_secondLaunch_usesCoreDataOnly() async {
        // Arrange
        let storedWeather = WeatherData(
            latitude: 27.7172,
            longitude: 85.3240
        )
        mockCoreData.storedWeather = [storedWeather]

        let updatedWeather = WeatherData(
            latitude: 27.7172,
            longitude: 85.3240
        )
        mockRepository.weatherResult = .success(updatedWeather)

        // Act – first launch (location-based)
        viewModel.validateAndLoadWeather()
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Reset tracking here
        mockLocation.reset()

        // Act – second launch (CoreData-based)
        viewModel.validateAndLoadWeather()
        try? await Task.sleep(nanoseconds: 300_000_000)

        // Assert
        XCTAssertFalse(mockLocation.getCurrentLocationCalled)
        XCTAssertEqual(viewModel.weatherList.count, 1)
        XCTAssertEqual(viewModel.weatherList.first?.latitude, 27.7172)
    }
    
    
    func test_locationPermissionDenied_showsAlert() async {
        mockLocation.result = .failure(LocationError.permissionDenied)

        viewModel.validateAndLoadWeather()
        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertTrue(viewModel.showLocationPermissionAlert)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.weatherList.isEmpty)
    }
    
    func test_refreshAllWeather_updatesMultipleCities() async {
        let city1 = WeatherData(latitude: 10, longitude: 10)
        let city2 = WeatherData(latitude: 20, longitude: 20)

        mockCoreData.storedWeather = [city1, city2]
        mockRepository.weatherResultsQueue = [
            .success(city1),
            .success(city2)
        ]

        await viewModel.refreshAllWeather()

        XCTAssertEqual(viewModel.weatherList.count, 2)
    }
    
    func test_refreshAllWeather_partialFailure() async {
        let city1 = WeatherData(latitude: 10, longitude: 10)
        let city2 = WeatherData(latitude: 20, longitude: 20)

        mockCoreData.storedWeather = [city1, city2]
        mockRepository.weatherResultsQueue = [
            .success(city1),
            .failure(.noData)
        ]

        await viewModel.refreshAllWeather()

        XCTAssertEqual(viewModel.weatherList.count, 1)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
}


