//
//  FlickrAPIClient.swift
//  flickr
//
//  Created by Theo Ntogiakos on 22/09/2024.
//

import Foundation

protocol FlickrAPIClientProtocol {
    func getPhotos(search: Search) async -> [Photo]?
    func getPhotoInfo(photoId: String) async throws -> PhotoInfo?
    func getUsername(username: String) async throws -> String?
}

class FlickrAPIClient: FlickrAPIClientProtocol {
    let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getPhotos(search: Search) async -> [Photo]? {
        var userId: String?
        if !search.username.isEmpty {
            userId = try? await getUsername(username: search.username.lowercased())
        }
        return try? await performSearch(
            tags: search.tags,
            excludeTags: search.excludeTags,
            tagMode: search.includeAll ? "all" : "any",
            userId: userId ?? "",
            page: search.page,
            perPage: search.perPage
        )
    }
    
    func getPhotoInfo(photoId: String) async throws -> PhotoInfo? {
        let endpoint = Endpoint.getPhotoInfo(photoId: photoId)
        do {
            let response: PhotosGetInfoResponse = try await networkService.request(endpoint)
            return response.photo
        } catch {
            print("Error fetching data: \(error)")
            throw(error)
        }
    }
    
    private func performSearch(
        photoId: String = "",
        tags: String = "",
        excludeTags: String = "",
        tagMode: String = "any",
        userId: String = "",
        page: Int = 1,
        perPage: Int = 10
    ) async throws -> [Photo] {
        let endpoint = Endpoint.search(
            tags: tags,
            excludeTags: excludeTags,
            tagMode: tagMode,
            userId: userId,
            page: page,
            perPage: perPage
        )
        do {
            let response: PhotosSearchResponse = try await networkService.request(endpoint)
            return response.photos.photo
        } catch {
            print("Error fetching data: \(error)")
            throw(error)
        }
    }
    
    func getUsername(username: String) async throws -> String? {
        let endpoint = Endpoint.getUserId(username: username)
        
        do {
            let response: PeopleFindByUsernameResponse = try await networkService.request(endpoint)
            return response.user.nsid
        } catch {
            print("Error fetching data: \(error)")
            throw(error)
        }
    }
}
