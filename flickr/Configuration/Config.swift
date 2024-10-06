//
//  Config.swift
//  flickr
//
//  Created by Theo Ntogiakos on 06/10/2024.
//

import Foundation

class Config {
    static let flickrApiKey: String = {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist["FlickrApiKey"] as? String else {
            fatalError("APIKeys.plist not found or FlickrApiKey not set")
        }
        return apiKey
    }()
}
