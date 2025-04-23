import Foundation

struct AuthService: AuthServiceProtocol {
    func getAccessToken(with authCode: String, encodedToken: String, completion: @escaping (Result<AuthResponseModel, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .post,
            host: APIConstans.signInBaseUrl, 
            pathComponents: ["api", "token"],
            queryItems: [
                "code": authCode,
                "redirect_uri": APIConstans.redirectUri,
                "grant_type": "authorization_code"
            ],
            headerFields: [
                "Authorization": "Basic \(encodedToken)",
                "Content-Type" : "application/x-www-form-urlencoded",
            ]
        )
        
        let request = CodingRequest<AuthResponseModel>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func refreshAccessToken(with refreshToken: String, encodedToken: String, completion: @escaping (Result<AuthResponseModel, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .post,
            host: APIConstans.signInBaseUrl,
            pathComponents: ["api", "token"],
            queryItems: [
                "refresh_token": refreshToken,
                "grant_type": "refresh_token"
            ],
            headerFields: [
                "Authorization": "Basic \(encodedToken)",
                "Content-Type" : "application/x-www-form-urlencoded",
            ]
        )
        
        let request = CodingRequest<AuthResponseModel>(config: config)
        request.load(completion: completion)

        return request
    }
}
