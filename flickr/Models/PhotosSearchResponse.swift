//
//  PhotoSearch.swift
//  flickr
//
//  Created by Theo Ntogiakos on 19/09/2024.
//

import Foundation

struct PhotosSearchResponse: Codable {
    let photos: Photos
}

struct Photos: Codable{
    let photo: [Photo]
}

struct Photo: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ownername: String
    let iconserver: String
    let iconfarm: Int
    let tags: String
    let description: Description
    let datetaken: String
}

struct Description: Codable, Equatable, Hashable {
    let _content: String
}

extension Photo {
    var imageUrl: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
    
    var iconUrl: URL? {
        URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(owner).jpg")
    }
    
    var hashtagsList: [String] {
        tags == "" ? [] : tags.components(separatedBy: " ").map { tag in "#\(tag)" }
    }
    
    var hashtags: String {
        hashtagsList.joined(separator: " ")
    }
    
    var descriptionText: String {
        description._content
    }
}
