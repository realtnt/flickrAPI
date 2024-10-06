//
//  PhotoView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 23/09/2024.
//

import SwiftUI

struct PhotoView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: FlickrViewModel
    @State private var liked: Bool = false
    var photo: Photo
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            NavigationLink(destination: PhotoDetailView(viewModel: viewModel, photo: photo)) {
                LoadImageView(url: photo.imageUrl)
            }
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: liked ? "heart.fill" : "heart")
                        .foregroundStyle(liked ? .red : .gray)
                        .padding(.trailing, 8)
                        .padding(.top, 8)
                        .onTapGesture {
                            likePhoto(photo: photo)
                            liked.toggle()
                        }
                }
                Spacer()
                PhotoInfoView(viewModel: viewModel, photo: photo)
            }
        }
        .cornerRadius(5)
    }
    
    func likePhoto(photo: Photo) {
        guard let url = photo.imageUrl else { return }
        let likedPhoto = LikedPhoto(id: photo.id, url: url)
        modelContext.insert(likedPhoto)
    }
}

struct LoadImageView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .scaleEffect(1.2)
            case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(minHeight: 300)
            @unknown default:
                EmptyView()
            }
        }
    }
}
