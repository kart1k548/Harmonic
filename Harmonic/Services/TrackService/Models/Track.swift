import Foundation

struct Tracks: Codable {
    let items: [Track]?
    let total: Int?
}

struct Track: Codable {
    let track: TrackDetail
}

struct TrackDetail: Codable {
    let album: Album?
    let artists: [Artist]
    let availableMarkets: [String]
    let type: String
    let discNumber: Int
    let duration: Int
    let explicit: Bool
    let id: String
    let name: String
    let externalUrls: ExternalUrl
    
    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case type
        case discNumber = "disc_number"
        case duration = "duration_ms"
        case explicit
        case id
        case name
        case externalUrls = "external_urls"
    }
}

extension TrackDetail: Hashable {
    static func == (lhs: TrackDetail, rhs: TrackDetail) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
