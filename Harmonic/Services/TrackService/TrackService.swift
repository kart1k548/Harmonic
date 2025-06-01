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
    
    func saveTrack(with accessToken: String, trackId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .put,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "tracks"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<Data?>(config: config)
        request.load(payload: ["ids": [trackId]], completion: completion)

        return request
    }
    
    func isTrackSaved(with accessToken: String, trackId: String, completion: @escaping (Result<[Bool], Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "tracks", "contains"],
            queryItems: ["ids": trackId],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<[Bool]>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func removeSavedTrack(with accessToken: String, trackId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .delete,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "tracks"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<NewReleasesResponseModel>(config: config)
        request.load(payload: ["ids": [trackId]], completion: completion)

        return request
    }
}
