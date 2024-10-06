//
//  PhotoLoaderView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 30/09/2024.
//

import SwiftUI

struct PhotoLoaderView: View {
    @ObservedObject var viewModel: FlickrViewModel
    let photoId: String
    @State private var photo: Photo?
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let photo {
                PhotoDetailView(viewModel: viewModel, photo: photo)
            } else if let error = self.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                Text("Loading...")
            }
        }
        .task {
            await loadPhotoInfo()
        }
    }
    
    func loadPhotoInfo() async {
        isLoading = true
        do {
            photo = try await viewModel.fetchPhotoInfo(photoId: photoId)
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
