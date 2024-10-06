//
//  SearchView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 23/09/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: FlickrViewModel
    @Binding var isPresented: Bool
    @State private var searchTags = ""
    @State private var excludeTags = ""
    @State private var username = ""
    @State private var searchForAllTags = false

    var body: some View {
        VStack {
            TextField("Tags to search for", text: $searchTags)
                .textFieldStyle(.roundedBorder)
            TextField("Tags to exclude from search (optional)", text: $excludeTags)
                .textFieldStyle(.roundedBorder)
            Toggle("Search for all tags", isOn: $searchForAllTags)
                .padding(.bottom, 16)
            TextField("Search by username", text: $username)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button("Search") {
                    viewModel.fetchPhotos(
                        with: searchTags,
                        without: excludeTags,
                        includeAll: searchForAllTags,
                        username: username
                    )
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 16)
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    SearchView(viewModel: FlickrViewModel(), isPresented: .constant(true))
}
