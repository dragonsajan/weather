//
//  ApiServiceProtocol.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

protocol ApiServiceProtocol {
    
    
    /// Api Request
    /// - Parameter endpoint: Any Structure of conforming ApiEndPoint protocol
    /// - Returns: Send back the <T> Generic
    func request<T: Decodable, Endpoint: ApiEndPoint>(_ endpoint: Endpoint) async -> Result<T, ApiError>
    
}
