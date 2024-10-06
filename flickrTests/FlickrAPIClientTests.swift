//
//  FlickrAPIClientTests.swift
//  flickr
//
//  Created by Theo Ntogiakos on 05/10/2024.
//

import XCTest
import Foundation
@testable import flickr

class FlickrAPIClientTests: XCTestCase {
    var sut: FlickrAPIClient!
    var networkService: NetworkService!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        networkService = NetworkService(urlSession: urlSession)
        sut = FlickrAPIClient(networkService: networkService)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func readJsonFile(named fileName: String) throws -> String? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            XCTFail("File not found: \(fileName).json")
            return nil
        }
        
        return try String(contentsOfFile: path, encoding: .utf8)
    }
    
    func prepareResponse(for endpointUrl: URL, with data: Data?) {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url,
                  url == endpointUrl else {
                throw NetworkError.request
            }
            
            let response = HTTPURLResponse(url: endpointUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    func testGetPhotos() {
        // TODO: Write test
    }
    
    func testGetPhotoInfo() {
        // TODO: Write test
    }
    
    func testGetUsername() {
        // TODO: Write test
    }
}
