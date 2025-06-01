import Foundation

protocol TrackServiceProtocol {
    func getSavedTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol
    func getRecentTracks(with accessToken: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> RequestProtocol
    func saveTrack(with accessToken: String, trackId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol
    func isTrackSaved(with accessToken: String, trackId: String, completion: @escaping (Result<[Bool], Error>) -> Void) -> RequestProtocol
    func removeSavedTrack(with accessToken: String, trackId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol
}
