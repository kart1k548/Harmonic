import Foundation

struct ProfileService: ProfileServiceProtocol {
    func getUserProfile(with accessToken: String, completion: @escaping (Result<UserProfile, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<UserProfile>(config: config)
        request.load(completion: completion)

        return request
    }
}
