import Foundation

struct NewReleasesResponseModel: Codable {
    let albums: Albums
}

struct AlbumTracks: Codable {
    let items: [TrackDetail]
}

struct Albums: Codable {
    let items: [Album]
}

struct Album: Codable {
    let albumType: String
    let availableMarkets: [String]
    let type: String
    let id: String
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let images: [APIImage]
    let artists: [Artist]
    let externalUrls: ExternalUrl
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case type
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case id
        case images
        case name
        case artists
        case externalUrls = "external_urls"
    }
}

struct ExternalUrl: Codable {
    let spotify: String
}


