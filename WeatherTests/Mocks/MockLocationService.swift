//
//  Mocks.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import CoreLocation
@testable import Weather

final class MockLocationService: LocationServiceProtocol {

    var result: Result<CLLocationCoordinate2D, Error>?
    private(set) var getCurrentLocationCalled = false

    func getCurrentLocation(
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        getCurrentLocationCalled = true
        if let result {
            completion(result)
        }
    }

    // Reset for multi-phase tests
    func reset() {
        getCurrentLocationCalled = false
        result = nil
    }

    // Unused delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {}
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
}
