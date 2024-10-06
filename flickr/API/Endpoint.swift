//
//  Endpoint.swift
//  flickr
//
//  Created by Theo Ntogiakos on 20/09/2024.
//

import Foundation

private let apiKey = Config.flickrApiKey

struct Endpoint {
    var path: String?
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        let commonQueryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/" + (path ?? "")
        components.queryItems = queryItems + commonQueryItems

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }

        return url
    }
}

extension Endpoint {
    static func getUserId(username: String) -> Self {
        return Endpoint(queryItems: [
            URLQueryItem(name: "method", value: "flickr.people.findByUsername"),
            URLQueryItem(name: "username", value: username)
            ])
    }
    
    static func getPhotoInfo(photoId: String) -> Self {
        return Endpoint(queryItems: [
            URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
            URLQueryItem(name: "photo_id", value: photoId )
        ])
    }
    
    static func search(tags: String = "",
                       excludeTags: String = "",
                       tagMode: String = "any",
                       userId: String = "",
                       page: Int = 1,
                       perPage: Int = 5,
                       safeSearch: Int = 1) -> Self {
        
        let extras = [
            "description",
            "date_taken",
            "owner_name",
            "icon_server",
            "icon_farm",
            "tags"
        ]
        let excludeTagsString = excludeTags.components(separatedBy: ",").map { "-\($0.lowercased())" }.joined(separator: ",")
        let tagsString = tags.lowercased() + (excludeTags.isEmpty ? "" : ",\(excludeTagsString)")
        let extrasString = extras.joined(separator: ",")
        
        return Endpoint(queryItems: [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "tags", value: tagsString),
            URLQueryItem(name: "tag_mode", value: tagMode),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "safe_search", value: "\(safeSearch)"),
            URLQueryItem(name: "extras", value: extrasString),
        ])
    }
}
