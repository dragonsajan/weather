//
//  ApiError.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

/// ApiError
///
/// Enum to map my api error
enum ApiError: LocalizedError {
    case invalidURL(String)
    case noData
    case decoding(Error)
    case decodingData(String)
    case serverError(statusCode: Int, response: String?)
    case networkFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .noData:
            return "No data received"
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .decodingData(let error):
            return "Decoding failed: \(error)"
        case .serverError(let code, let response):
            return "Server Error Code: \(code)" + "Response: \(response.map { ": \($0)" } ?? "")"
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
