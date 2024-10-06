//
//  MockNetworkService.swift
//  flickr
//
//  Created by Theo Ntogiakos on 01/10/2024.
//

@testable import flickr
import XCTest
import Foundation

class MockURLProtocol: URLProtocol {
    // 1. Handler to test the request and return mock response.
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
      guard let handler = MockURLProtocol.requestHandler else {
        fatalError("Handler is unavailable.")
      }
        
      do {
        // 2. Call handler with received request and capture the tuple of response and data.
        let (response, data) = try handler(request)
        
        // 3. Send received response to the client.
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data {
          // 4. Send received data to the client.
          client?.urlProtocol(self, didLoad: data)
        }
        
        // 5. Notify request has been finished.
        client?.urlProtocolDidFinishLoading(self)
      } catch {
        // 6. Notify received error.
        client?.urlProtocol(self, didFailWithError: error)
      }
    }
    
    override func stopLoading() {
        // ...
    }
}
