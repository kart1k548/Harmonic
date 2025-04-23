import Foundation

protocol PlaylistServiceProtocol {
    func getPlaylistDetails(with accessToken: String, playlistId: String, completion: @escaping (Result<Playlist, Error>) -> Void) -> RequestProtocol
}
