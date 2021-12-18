//
// Created by Desire L on 2021/12/17.
//

import Foundation

struct MovieModel: Codable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Codable {
    let title: String?
    let previewUrl: String?
    let imageUrl: String?
    let description: String?
    let price: Int?
    let currency: String?
    let releaseDate: String?


    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case previewUrl
        case imageUrl = "artworkUrl100"
        case price = "trackPrice"
        case description = "longDescription"
        case currency, releaseDate
    }
}