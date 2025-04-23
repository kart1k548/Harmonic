import Foundation

struct PlaylistService: PlaylistServiceProtocol {
    func getPlaylistDetails(with accessToken: String, playlistId: String, completion: @escaping (Result<Playlist, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "playlists", playlistId],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<Playlist>(config: config)
        request.load(completion: completion)

        return request
    }
}
