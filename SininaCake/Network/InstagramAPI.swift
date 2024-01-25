//
//  InstagramAPI.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

// MARK: - Insta
struct Instagram: Codable {
    let data: [InstaData]
    let paging: Paging
}

// MARK: - Data
struct InstaData: Codable, Identifiable {
    let id: String
    let caption: String?
    let mediaType: MediaType
    let mediaURL: String

    enum CodingKeys: String, CodingKey {
        case id, caption
        case mediaType = "media_type"
        case mediaURL = "media_url"
    }
}

enum MediaType: String, Codable {
    case carouselAlbum = "CAROUSEL_ALBUM"
    case image = "IMAGE"
}

// MARK: - Paging
struct Paging: Codable {
    let cursors: Cursors
    let next: String
}

// MARK: - Cursors
struct Cursors: Codable {
    let before, after: String
}
