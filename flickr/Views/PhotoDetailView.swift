//
//  PhotoDetailView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 23/09/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var fillScreen: Bool = false
    let viewModel: FlickrViewModel
    var photo: Photo
    
    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: photo.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: fillScreen ? .fill : .fit)
                    case .failure:
                        Image(systemName: "photo").foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .onTapGesture {
                    fillScreen.toggle()
                }
            }
            ScrollView {
                VStack {
                    HStack {
                        AsyncImage(url: photo.iconUrl) { image in
                            image
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                        }
                        Text(photo.ownername)
                            .font(.headline)
                    }
                    .padding(.bottom, 16)
                    .onTapGesture {
                        viewModel.fetchPhotos(username: photo.ownername)
                        presentationMode.wrappedValue.dismiss()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        DetailsTextView(title: "Title:", content: photo.title)
                        DetailsHTMLTextView(title: "Description", htmlContent: photo.descriptionText)
                        DetailsTextView(title: "Tags:", content: photo.hashtags)
                        DetailsTextView(title: "Date Taken:", content: photo.datetaken)
                    }
                }
                .padding()
            }
        }
    }
}

struct DetailsTextView: View {
    var title: String
    var content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(4)
                .background(content.isEmpty ? .gray : .blue)
                .cornerRadius(4)
                .frame(maxWidth: 85, alignment: .leading)
            Text(content)
                .font(.caption)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct DetailsHTMLTextView: View {
    @StateObject private var viewModel = DetailsHTMLTextViewModel()
    var title: String
    var htmlContent: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(4)
                .background(htmlContent.isEmpty ? .gray : .blue)
                .cornerRadius(4)
                .frame(maxWidth: 85, alignment: .leading)
            Text(viewModel.attributedString)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onAppear {
                    viewModel.updateAttributedString(text: htmlContent)
                }
        }
    }
}

#Preview {
    let photo = Photo(
        id: "54015806037",
        owner: "61969044@N07",
        secret: "a5ef3953ec",
        server: "65535",
        farm: 66,
        title: "",
        ownername: "bavarica",
        iconserver: "5532",
        iconfarm: 6,
        tags: "america northamerica",
        description: Description(_content: "This &quot;a&quot; <i>description</i>"),
        datetaken: "24/09/2024 01:34"
    )
    PhotoLoaderView(viewModel: FlickrViewModel(), photoId: photo.id)
}
