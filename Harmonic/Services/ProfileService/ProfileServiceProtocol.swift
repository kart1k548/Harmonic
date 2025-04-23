import Foundation

protocol ProfileServiceProtocol {
    func getUserProfile(with accessToken: String, completion: @escaping (Result<UserProfile, Error>) -> Void) -> RequestProtocol
}
