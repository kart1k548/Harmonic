import Foundation

struct AlbumService: AlbumServiceProtocol {
    func getAlbumTracks(with accessToken: String, albumId: String, completion: @escaping (Result<AlbumTracks, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "albums", albumId, "tracks"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<AlbumTracks>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func getNewReleases(with accessToken: String, completion: @escaping (Result<NewReleasesResponseModel, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "browse", "new-releases"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<NewReleasesResponseModel>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func saveAlbum(with accessToken: String, albumId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .put,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "albums"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<Data?>(config: config)
        request.load(payload: ["ids": [albumId]], completion: completion)

        return request
    }
    
    func isAlbumSaved(with accessToken: String, albumId: String, completion: @escaping (Result<[Bool], Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "albums", "contains"],
            queryItems: ["ids": albumId],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<[Bool]>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func removeSavedAlbum(with accessToken: String, albumId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .delete,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "me", "albums"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<NewReleasesResponseModel>(config: config)
        request.load(payload: ["ids": [albumId]], completion: completion)

        return request
    }
}
