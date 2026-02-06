//
//  AppSecrets.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

/// To load data from secret files
enum AppSecretKey: String, CaseIterable {
    case apiBaseURL = "API_BASE_URL"
    case weatherApiKey  = "WEATHER_API_KEY"
}

/// AppSecrets
///
/// This helps to load the data from xcconfig file to maintain security and not to push in git
enum AppSecrets {
    
    /// This function read the xcconfig file and gives back the value for given key
    ///
    /// - Parameter key: AppSecretKey : string title in xcconfige file
    /// - Returns: the value from xcconfig file for given key
    static func getValueFor(_ key: AppSecretKey) -> String {
        guard let value = Bundle.main.object(
            forInfoDictionaryKey: key.rawValue
        ) as? String,
        !value.isEmpty else {
            fatalError("Missing secret keyValue: \(key.rawValue)")
        }
        return value
    }
    
    /// This function help to veify if the xcconfig file has all the required key or not
    static func verifyAllSecretsExist() {
            var missing: [AppSecretKey] = []
            
            for key in AppSecretKey.allCases {
                guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String,
                      !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    missing.append(key)
                    continue
                }
            }
            
            if !missing.isEmpty {
                let missingKeys = missing.map { $0.rawValue }.joined(separator: ", ")
                fatalError("Missing or empty secrets: \(missingKeys)")
            }
        }
}
