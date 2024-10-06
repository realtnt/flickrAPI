//
//  ContentView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 18/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlickrViewModel()
    @State private var showSearchModal = false
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List(viewModel.photos) { photo in
                    VStack(spacing: 0) {
                        PhotoView(viewModel: viewModel, photo: photo)
                        TagsView(viewModel: viewModel, tagsList: photo.hashtagsList)
                    }
                    .padding(.bottom, 12)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listStyle(.plain)
                    .navigationTitle("Flickr Photos")
                    .id(photo.id)
                    .onChange(of: viewModel.photos.first) {
                        withAnimation {
                            proxy.scrollTo(viewModel.photos.first?.id, anchor: .top)
                        }
                    }
                    .onAppear() {
                        if photo.id == viewModel.photos.last?.id {
                            viewModel.fetchNextPage()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            viewModel.fetchPreviousPhotos()
                        }) {
                            if viewModel.searchHistory.count > 1 {
                                Image(systemName: "chevron.backward")
                            }
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSearchModal = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        NavigationLink(destination: LikedPhotos()) {
                            Image(systemName: "heart.fill")
                        }
                    }
                }
                .sheet(isPresented: $showSearchModal) {
                    SearchView(viewModel: viewModel, isPresented: $showSearchModal)
                        .presentationDetents([.fraction(0.35)])
                }
            }
        }
        .onAppear() {
            viewModel.fetchDefaultPhotos()
        }
    }
}

#Preview {
    ContentView()
}
