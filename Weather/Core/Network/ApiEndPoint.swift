//
//  ApiEndPoint.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

protocol ApiEndPoint {
    
    var path: String { get }
    var httpMethod: String { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    
}

extension ApiEndPoint {
    
    var baseURL: String { AppSecrets.getValueFor(.apiBaseURL) }
    var httpMethod: String { "GET" }
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    
    func urlRequest() throws -> URLRequest {
        
        let fullPath = baseURL + path
        var components = URLComponents(string: fullPath)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw ApiError.invalidURL(fullPath)
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        if let body = body { request.httpBody = body }
        
        return request
    }
}
