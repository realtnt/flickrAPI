//
//  FlickrViewModelTests.swift
//  flickr
//
//  Created by Theo Ntogiakos on 05/10/2024.
//

import XCTest
import Foundation
import Combine
@testable import flickr

class FlickrViewModelTests: XCTestCase {
    var sut: FlickrViewModel!
    var cancellable: AnyCancellable?
    
    override func setUp() {
        let mockFlickrAPIClient = MockFlickrAPIClient()
        sut = FlickrViewModel(flickrAPIClient: mockFlickrAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchDefaultPhotos() {
        let expectation = XCTestExpectation(description: "photos wasn't updated")
        
        cancellable = sut.$photos
            .sink { value in
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPreviousPhotos() {
        // TODO: Write test
    }
    
    func testFetchNextPage() {
        // TODO: Write test
    }
    
    func testFetchPhotoInfo() async throws {
        guard let photo = try await sut.fetchPhotoInfo(photoId: "540281535233") else {
            XCTFail("No photo found")
            return
        }
        XCTAssertEqual(photo.id, "54028153523", "Wrong id")
        XCTAssertEqual(photo.secret, "bfcf8d95dd", "Wrong secret")
        XCTAssertEqual(photo.server, "65535", "Wrong server")
        XCTAssertEqual(photo.farm, 66, "Wrong farm")
    }
    
    func testFetchPhotos() {
        // TODO: Write test
    }
}
