//
//  LikedPhotos.swift
//  flickr
//
//  Created by Theo Ntogiakos on 30/09/2024.
//

import SwiftUI
import SwiftData

struct LikedPhotos: View {
    @Query private var photos: [LikedPhoto]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(photos) { photo in
                    NavigationLink(destination: LikedPhotoView(photoId: photo.id)) {
                        AsyncImage(url: photo.url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LikedPhotos()
}

struct LikedPhotoView: View {
    let photoId: String
    
    var body: some View {
        Text("view")
    }
}
