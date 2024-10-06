//
//  flickrApp.swift
//  flickr
//
//  Created by Theo Ntogiakos on 18/09/2024.
//

import SwiftUI
import SwiftData

@main
struct flickrApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: LikedPhoto.self)
    }
}
