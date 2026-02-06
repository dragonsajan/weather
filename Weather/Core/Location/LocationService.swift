//
//  LocationService.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import CoreLocation
import UIKit

enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location access is disabled. Enable it in Settings to get local weather."
        case .locationUnavailable:
            return "Unable to fetch your current location."
        }
    }
}

final class LocationService: NSObject {

    static let shared = LocationService()

    private let manager = CLLocationManager()
    private var completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?

    private override init() {
        super.init()
        manager.delegate = self
    }

    func getCurrentLocation(
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        self.completion = completion

        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            completion(.failure(LocationError.permissionDenied))

        @unknown default:
            completion(.failure(LocationError.permissionDenied))
        }
    }
}


extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        let status = manager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            completion?(.failure(LocationError.permissionDenied))
            completion = nil

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else {
            completion?(.failure(LocationError.locationUnavailable))
            completion = nil
            return
        }

        completion?(.success(coordinate))
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        completion?(.failure(error))
        completion = nil
    }
}
