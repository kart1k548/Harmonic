import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private var _session: LoginSession?
    private let authService: AuthServiceProtocol
    private var authRequest: RequestProtocol?
    private var refreshRequest: RequestProtocol?
    
    private init() {
        if let accessToken = UserDefaults.standard.string(forKey: "access_token"),
           let refreshToken = UserDefaults.standard.string(forKey: "refresh_token"),
           let expirationDate = UserDefaults.standard.object(forKey: "expiration_date") as? Date {
            _session = LoginSession(accessToken: accessToken, refreshToken: refreshToken, tokenExpirationDate: expirationDate)
        }
        self.authService = AuthService()
    }
    
    private func cacheToken(with response: AuthResponseModel) {
        UserDefaults.standard.setValue(response.accessToken, forKey: "access_token")
        if let refreshToken = response.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expiresIn)), forKey: "expiration_date")
    }
    
    private func updateSession(with response: AuthResponseModel) {
        guard let refreshToken = response.refreshToken else {
            if let session = _session {
                _session = LoginSession(
                    accessToken: response.accessToken,
                    refreshToken: session.refreshToken,
                    tokenExpirationDate: Date().addingTimeInterval(TimeInterval(response.expiresIn))
                )
            }
            return
        }
        _session = LoginSession(
            accessToken: response.accessToken,
            refreshToken: refreshToken,
            tokenExpirationDate: Date().addingTimeInterval(TimeInterval(response.expiresIn))
        )
    }
    
    func getSession(authCode: String? = nil, completion: @escaping (LoginSession?) -> Void) {
        guard let session = _session else {
            if let authCode {
                getAccessToken(authCode: authCode) { [weak self] didReceiveToken in
                    didReceiveToken ? completion(self?._session) : completion(nil)
                }
                return
            }
            completion(nil)
            return
        }
        
        guard session.shouldRefreshToken else {
            completion(_session)
            return
        }
        
        refreshAccessToken { [weak self] isRefreshed in
            isRefreshed ? completion(self?._session) : completion(nil)
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        refreshRequest?.cancel()
        
        guard let encodedToken = "\(APIConstans.clientID):\(APIConstans.clientSecret)".data(using: .utf8)?.base64EncodedString() else {
            print("Encoding token failed")
            completion(false)
            return
        }
        
        guard let refreshToken = _session?.refreshToken else {
            print("No session")
            completion(false)
            return
        }
        
        refreshRequest = authService.refreshAccessToken(with: refreshToken, encodedToken: encodedToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.cacheToken(with: data)
                    self?.updateSession(with: data)
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            }
        }
    }
    
    private func getAccessToken(authCode: String, completion: @escaping (Bool) -> Void) {
        authRequest?.cancel()
        
        guard let encodedToken = "\(APIConstans.clientID):\(APIConstans.clientSecret)".data(using: .utf8)?.base64EncodedString() else {
            completion(false)
            return
        }
        
        authRequest = authService.getAccessToken(with: authCode, encodedToken: encodedToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.cacheToken(with: data)
                    self?.updateSession(with: data)
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print(error)
                }
            }
        }
    }
}
