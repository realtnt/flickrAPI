//
//  PhotosGetInfoResponse.swift
//  flickr
//
//  Created by Theo Ntogiakos on 30/09/2024.
//

import Foundation

struct PhotosGetInfoResponse: Codable {
    let photo: PhotoInfo
}

struct PhotoInfo: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let owner: Owner
    let title: Title
    let description: Description
    let tags: Tags
    let dates: Dates
}

struct Owner: Codable {
    let nsid: String
    let username: String
    let realname: String
    let iconserver: String
    let iconfarm: Int
}

struct Title: Codable {
    let _content: String
}

struct Tags: Codable {
    let tag: [Tag]
}

struct Tag: Codable {
    let _content: String
}

struct Dates: Codable {
    let taken: String
}

extension PhotoInfo {
    var imageUrl: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
    
    var iconUrl: URL? {
        URL(string: "https://farm\(owner.iconfarm).staticflickr.com/\(owner.iconserver)/buddyicons/\(owner.nsid).jpg")
    }
    
    var tagsText: String {
        tags.tag.isEmpty ? "" : tags.tag.map { tag in tag._content }.joined(separator: " ")
    }
    
    var ownername: String {
        owner.username
    }
    
    var descriptionText: String {
        description._content
    }
    
    var titleText: String {
        title._content
    }
    
    var datetaken: String {
        dates.taken
    }
}
