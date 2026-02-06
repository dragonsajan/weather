//
//  ApiService.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import Foundation

actor ApiService: ApiServiceProtocol {
    // main session
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable, Endpoint: ApiEndPoint>(_ endpoint: Endpoint) async -> Result<T, ApiError> {
        do {
            let request = try await endpoint.urlRequest()
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.noData)
            }
            
            // Check Error for case other than 2XX
            if !(200..<300).contains(httpResponse.statusCode) {
                let responseString = String(data: data, encoding: .utf8)
                return .failure(.serverError(statusCode: httpResponse.statusCode, response: responseString))
            }
            
            // Check for empty responses
            guard !data.isEmpty else {
                return .failure(.noData)
            }
            
            // Decode success response
            let decoded = try JSONDecoder().decode(T.self, from: data)
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response JSON:\n\(jsonString)")
            }
            #endif
            return .success(decoded)
            
        } catch let error as ApiError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(.decoding(error))
        } catch {
            return .failure(.networkFailure(error))
        }
    }
}
