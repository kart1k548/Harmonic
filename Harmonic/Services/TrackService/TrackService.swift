import Foundation

struct TrackService: TrackServiceProtocol {
    func getSavedTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "tracks"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<Tracks>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func getRecentTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "player", "recently-played"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<Tracks>(config: config)
        request.load(completion: completion)

        return request
    }
}
