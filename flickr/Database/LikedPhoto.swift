//
//  FavPhoto.swift
//  flickr
//
//  Created by Theo Ntogiakos on 29/09/2024.
//

import Foundation
import SwiftData

@Model
final class LikedPhoto: Identifiable {
    @Attribute(.unique)
    var id: String
    var url: URL
    var timestamp: Date
    
    init(id: String, url: URL, timestamp: Date = .now) {
        self.id = id
        self.url = url
        self.timestamp = timestamp
    }
}
