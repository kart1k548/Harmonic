import Foundation

struct UserProfile: Codable {
    let country: String
    let name: String
    let email: String
    let explicitContent: ExplicitContentModel
    let followers: FollowerModel
    let id: String
    let product: String
    let images: [APIImage]
    
    enum CodingKeys: String, CodingKey {
        case country
        case name = "display_name"
        case email
        case explicitContent = "explicit_content"
        case followers
        case id
        case product
        case images
    }
}

struct ExplicitContentModel: Codable {
    let filterEnabled: Bool
    let filterLocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

struct APIImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
    
    enum Resolution {
        case high
        case medium
        case low
    }
}

struct FollowerModel: Codable {
    let total: Int
}
