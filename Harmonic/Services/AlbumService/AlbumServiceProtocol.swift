import Foundation

protocol AlbumServiceProtocol {
    func getNewReleases(with accessToken: String, completion: @escaping (Result<NewReleasesResponseModel, Error>) -> Void) -> RequestProtocol
    func getAlbumTracks(with accessToken: String, albumId: String, completion: @escaping (Result<AlbumTracks, Error>) -> Void) -> RequestProtocol
    func saveAlbum(with accessToken: String, albumId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol
    func isAlbumSaved(with accessToken: String, albumId: String, completion: @escaping (Result<[Bool], Error>) -> Void) -> RequestProtocol
    func removeSavedAlbum(with accessToken: String, albumId: String, completion: @escaping (Result<Data?, Error>) -> Void) -> RequestProtocol
}
