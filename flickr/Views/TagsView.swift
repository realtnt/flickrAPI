//
//  TagsView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 20/09/2024.
//

import SwiftUI

struct TagsView: View {
    @ObservedObject var viewModel: FlickrViewModel
    var tagsList: [String] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(tagsList, id: \.self) { tag in
                    Button {
                        viewModel.fetchPhotos(with: tag)
                    } label: {
                        Text("\(tag)")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(12)
                            .frame(maxHeight: 20)
                            .background(.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .lineLimit(4)
                    }
                }
            }
        }
    }
}

#Preview {
    TagsView(viewModel: FlickrViewModel(), tagsList: ["tag1", "tag2", "tag3", "tag4", "tag5"])
}
