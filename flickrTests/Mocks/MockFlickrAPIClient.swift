//
//  MockFlickrAPIClient.swift
//  flickr
//
//  Created by Theo Ntogiakos on 05/10/2024.
//

import Foundation
import XCTest
@testable import flickr

class MockFlickrAPIClient: FlickrAPIClientProtocol {
    func getPhotos(search: Search) async -> [Photo]? {
        let response: PhotosSearchResponse? = decodeJson(named: "photos_search")
        return response?.photos.photo
    }
    
    func getPhotoInfo(photoId: String) async throws -> PhotoInfo? {
        let response: PhotosGetInfoResponse? = decodeJson(named: "photos_getInfo")
        return response?.photo
    }
    
    func getUsername(username: String) async throws -> String? {
        return nil
    }
    
    private func decodeJson<T: Decodable>(named fileName: String) -> T? {
        guard let data = readJsonFile(named: fileName) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    private func readJsonFile(named fileName: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            XCTFail("File not found: \(fileName).json")
            return nil
        }
        let json = try? String(contentsOfFile: path, encoding: .utf8)
        guard let json else { return nil }
        
        return json.data(using: .utf8)
    }
}
