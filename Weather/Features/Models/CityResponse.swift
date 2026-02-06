//
//  CityResponse.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

//
//  CitySearchResponse.swift
//  Weather
//

import Foundation

struct CityResponse: Codable {

    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
}
