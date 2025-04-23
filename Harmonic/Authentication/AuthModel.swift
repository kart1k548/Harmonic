import Foundation

protocol AuthModelDelegate: AnyObject {
    func didReceiveAccessToken(isSuccess: Bool)
}

class AuthModel {
    private let authService: AuthServiceProtocol
    
    // carries the logic to be executed on SignInViewController
    var completionHandler: ((Bool) -> Void)?
    
    weak var delegate: AuthModelDelegate?
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func authenticate(authCode: String) {
        AuthManager.shared.getSession(authCode: authCode) { [weak self] session in
            guard session != nil else {
                self?.delegate?.didReceiveAccessToken(isSuccess: false)
                self?.completionHandler?(false)
                return
            }
            self?.delegate?.didReceiveAccessToken(isSuccess: true)
            self?.completionHandler?(true)
        }
    }
}
