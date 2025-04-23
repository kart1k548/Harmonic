import Foundation

protocol AuthServiceProtocol {
    func getAccessToken(with authCode: String, encodedToken: String, completion: @escaping (Result<AuthResponseModel, Error>) -> Void) -> RequestProtocol
    func refreshAccessToken(with authCode: String, encodedToken: String, completion: @escaping (Result<AuthResponseModel, Error>) -> Void) -> RequestProtocol
}
