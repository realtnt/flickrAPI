//
//  FlickrViewModel.swift
//  flickr
//
//  Created by Theo Ntogiakos on 19/09/2024.
//

import Foundation

struct Search {
    let tags: String
    let excludeTags: String
    let includeAll: Bool
    let username: String
    let page: Int
    let perPage: Int
}

class FlickrViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var searchHistory: [Search] = []
    
    private let flickrAPIClient: FlickrAPIClientProtocol
    
    init(flickrAPIClient: FlickrAPIClientProtocol = FlickrAPIClient()) {
        self.flickrAPIClient = flickrAPIClient
    }
    
    func fetchDefaultPhotos() {
        fetchPhotos(with: "yorkshire")
    }
    
    func fetchPreviousPhotos() {
        if let search = pop() {
            fetchPhotos(
                with: search.tags,
                without: search.excludeTags,
                includeAll: search.includeAll,
                username: search.username,
                page: search.page,
                perPage: search.perPage
            )
        }
    }
    
    func fetchNextPage() {
        if let search = searchHistory.last {
            fetchPhotos(
                with: search.tags,
                without: search.excludeTags,
                includeAll: search.includeAll,
                username: search.username,
                page: search.page + 1,
                perPage: search.perPage,
                newSearch: false
            )
        }
    }
    
    func fetchPhotoInfo(photoId: String) async throws -> Photo? {
        guard let photoInfo = try await flickrAPIClient.getPhotoInfo(photoId: photoId) else { return nil }
            
        return Photo(
            id: photoInfo.id,
            owner: photoInfo.owner.nsid,
            secret: photoInfo.secret,
            server: photoInfo.server,
            farm: photoInfo.farm,
            title: photoInfo.titleText,
            ownername: photoInfo.ownername,
            iconserver: photoInfo.owner.iconserver,
            iconfarm: photoInfo.owner.iconfarm,
            tags: photoInfo.tagsText,
            description: photoInfo.description,
            datetaken: photoInfo.datetaken
        )
    }
    
    func fetchPhotos(
        with tags: String = "",
        without excludeTags: String = "",
        includeAll: Bool = false,
        username: String = "",
        page: Int = 1,
        perPage: Int = 10,
        newSearch: Bool = true
    ) {
        if tags.isEmpty && username.isEmpty { return }
        Task { @MainActor in
            let search = Search(
                tags: tags,
                excludeTags: excludeTags,
                includeAll: includeAll,
                username: username,
                page: page,
                perPage: perPage
            )
            
            let newPhotos = await flickrAPIClient.getPhotos(search: search) ?? []
            
            if newSearch {
                photos = newPhotos
            } else {
                photos.append(contentsOf: newPhotos)
                photos = photos.uniqued()
            }
            
            if !photos.isEmpty {
                if !newSearch {
                    searchHistory.removeLast()
                }
                push(search: search)
            }
        }
    }
    
    private func pop() -> Search? {
        guard !searchHistory.isEmpty else { return nil }
        searchHistory.removeLast()
        return searchHistory.popLast()
    }
    
    private func push(search: Search) {
        searchHistory.append(search)
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
