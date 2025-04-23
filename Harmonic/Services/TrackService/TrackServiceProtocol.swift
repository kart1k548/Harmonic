import Foundation

protocol TrackServiceProtocol {
    func getSavedTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol
    func getRecentTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol
}
