//
//  PhotoInfoView.swift
//  flickr
//
//  Created by Theo Ntogiakos on 21/09/2024.
//

import SwiftUI

struct PhotoInfoView: View {
    @ObservedObject var viewModel: FlickrViewModel
    var photo: Photo
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(photo.title)
                .font(.footnote)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.bottom, 8)
            HStack {
                AsyncImage(url: photo.iconUrl) { image in
                    image
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                }
                Text(photo.ownername)
                    .font(.footnote)
                    .foregroundStyle(.white)
                Spacer()
            }
            .onTapGesture {
                viewModel.fetchPhotos(username: photo.ownername)
            }
        }
        .padding(.bottom, 8)
        .padding(.top, 16)
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [.clear, Color.black.opacity(0.6), Color.black.opacity(0.8)]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PhotoInfoView(viewModel: FlickrViewModel(),
        photo: Photo(
            id: "54007724780",
            owner: "96541566@N06",
            secret: "29cbbf3a52",
            server: "65535",
            farm: 66,
            title: "2020-03-22_09-31-06_Costa_Rica_-_Puerto_Viejo_K70_JH",
            ownername: "Juhele_CZ",
            iconserver: "7292",
            iconfarm: 8,
            tags: "america northamerica centralamerica centralamericanregion republicofcostarica costarica repúblicadecostarica nicaragua caribbeansea panama pacificocean ecuador cocosisland vegetation plants puertoviejodetalamanca puertoviejo coastal town talamanca limónprovince sea ocean beaches beach forest jungle trees walk enchantedforest magic sunrays backlight magical seashore shore tourism landscape animal sloth hoffmannstwotoedsloth choloepushoffmanni northerntwotoedsloth choloepodidae choloepus road journey travel gmic gimp",
            description: Description(_content: ""),
            datetaken: "2024-09-21 12:46:01"
        )
    )
}
