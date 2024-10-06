//
//  NetworkService.swift
//  flickr
//
//  Created by Theo Ntogiakos on 20/09/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

enum NetworkError: Error {
    case request
    case badResponse
    case decodingError
}

class NetworkService: NetworkServiceProtocol {
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await urlSession.data(from: endpoint.url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw NetworkError.decodingError
        }
    }
}
