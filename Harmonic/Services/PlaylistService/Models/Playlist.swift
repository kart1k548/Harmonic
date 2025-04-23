import Foundation

struct Playlist: Decodable {
    let description: String
    let name: String
    let id: String
    let images: [APIImage]
    let owner: User
    let type: String
    let tracks: Tracks
    let externalUrls: ExternalUrl
    
    enum CodingKeys: String, CodingKey {
        case description
        case name
        case id
        case images
        case owner
        case type
        case tracks
        case externalUrls = "external_urls"
    }
}

struct User: Codable {
    let displayName: String
    let id: String
    let externalUrls: ExternalUrl
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
