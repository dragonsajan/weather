//
//  CityData.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import Foundation

struct CityData: Identifiable, Hashable {

    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?

    var displayName: String {
        if let state {
            return "\(name), \(state), \(country)"
        }
        return "\(name), \(country)"
    }
}


extension CityData {

    static func map(from responses: [CityResponse]) -> [CityData] {

        responses.compactMap { response in
            guard
                let name = response.name,
                let lat = response.lat,
                let lon = response.lon,
                let country = response.country
            else {
                return nil
            }

            return CityData(
                id: "\(name)-\(lat)-\(lon)",   
                name: name,
                latitude: lat,
                longitude: lon,
                country: country,
                state: response.state
            )
        }
    }
}
