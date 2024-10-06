//
//  PeopleFindByUsername.swift
//  flickr
//
//  Created by Theo Ntogiakos on 23/09/2024.
//

struct PeopleFindByUsernameResponse: Codable {
    let user: User
}

struct User: Codable {
    let nsid: String
}
