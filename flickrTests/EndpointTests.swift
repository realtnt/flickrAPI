//
//  EndpointTests.swift
//  flickr
//
//  Created by Theo Ntogiakos on 04/10/2024.
//

import XCTest
import Foundation
@testable import flickr

class EndpointTests: XCTestCase {
    var sut: Endpoint!
    
    func queryItemValue(for name: String, in url: URL) -> String? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let item = components.queryItems?.first(where: { $0.name == name })
        else {
            return nil
        }
        return item.value
    }
    
    func testPhotosSearch() {
        sut = .search(tags: "yorkshire")
        
        XCTAssertEqual(queryItemValue(for: "method", in: sut.url), "flickr.photos.search")
        XCTAssertEqual(queryItemValue(for: "user_id", in: sut.url), "")
        XCTAssertEqual(queryItemValue(for: "tags", in: sut.url), "yorkshire")
        XCTAssertEqual(queryItemValue(for: "tag_mode", in: sut.url), "any")
        XCTAssertEqual(queryItemValue(for: "page", in: sut.url), "1")
        XCTAssertEqual(queryItemValue(for: "per_page", in: sut.url), "5")
        XCTAssertEqual(queryItemValue(for: "safe_search", in: sut.url), "1")
        XCTAssertEqual(queryItemValue(for: "extras", in: sut.url), "description,date_taken,owner_name,icon_server,icon_farm,tags")
        XCTAssertEqual(queryItemValue(for: "format", in: sut.url), "json")
        XCTAssertEqual(queryItemValue(for: "nojsoncallback", in: sut.url), "1")
    }
    
    func testPhotosGetInfo() {
        sut = .getPhotoInfo(photoId: "54028153523")

        XCTAssertEqual(queryItemValue(for: "method", in: sut.url), "flickr.photos.getInfo")
        XCTAssertEqual(queryItemValue(for: "photo_id", in: sut.url), "54028153523")
        XCTAssertEqual(queryItemValue(for: "format", in: sut.url), "json")
        XCTAssertEqual(queryItemValue(for: "nojsoncallback", in: sut.url), "1")
    }
    
    func testPeopleFindByUsername() {
        sut = .getUserId(username: "jaciii (off&on)")
        
        XCTAssertEqual(queryItemValue(for: "method", in: sut.url), "flickr.people.findByUsername")
        XCTAssertEqual(queryItemValue(for: "username", in: sut.url), "jaciii (off&on)")
        XCTAssertEqual(queryItemValue(for: "format", in: sut.url), "json")
        XCTAssertEqual(queryItemValue(for: "nojsoncallback", in: sut.url), "1")
    }
}
