//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Created by Theo Ntogiakos on 18/09/2024.
//

import XCTest
import Foundation
@testable import flickr

class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        sut = NetworkService(urlSession: urlSession)
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
    
    func testPhotoSearchResponse() async throws {
        let endpoint = Endpoint.search()
        let url = endpoint.url
        let data = try readJsonFile(named: "photos_search")?.data(using: .utf8)
  
        prepareResponse(for: url, with: data)
        
        let response: PhotosSearchResponse = try await sut.request(endpoint)
        XCTAssertEqual(response.photos.photo.count, 5, "Incorrect Count")
    }
    
    func testPhotosGetInfoResponse() async throws {
        let endpoint = Endpoint.getPhotoInfo(photoId: "54028153523")
        let url = endpoint.url
        let data = try readJsonFile(named: "photos_getInfo")?.data(using: .utf8)
  
        prepareResponse(for: url, with: data)
        
        let response: PhotosGetInfoResponse = try await sut.request(endpoint)
        XCTAssertEqual(response.photo.secret, "bfcf8d95dd", "Incorrect secret")
        XCTAssertEqual(response.photo.server, "65535", "Incorrect server")
        XCTAssertEqual(response.photo.farm, 66, "Incorrect farm")
        XCTAssertEqual(response.photo.ownername, "jaciii (off&on)", "Incorrect ownername")
        XCTAssertEqual(response.photo.titleText, "Lorenzo or Lawrence Ruiz_Explore_DSC07437", "Incorrect titleText")
        XCTAssertEqual(response.photo.datetaken, "2024-09-13 09:33:57", "Incorrect datetaken")
    }
    
    func testPeopleFindByUsernameResponse() async throws {
        let endpoint = Endpoint.getUserId(username: "jaciii (off&on)")
        let url = endpoint.url
        let data = try readJsonFile(named: "people_findByUsername")?.data(using: .utf8)
  
        prepareResponse(for: url, with: data)
        
        let response: PeopleFindByUsernameResponse = try await sut.request(endpoint)
        XCTAssertEqual(response.user.nsid, "10112197@N02", "Incorrect nsid")
    }
}
