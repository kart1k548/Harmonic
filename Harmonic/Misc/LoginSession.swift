import Foundation

struct LoginSession: Equatable {
    private let _accessToken: String
    private let _refreshToken: String
    private let _tokenExpirationDate: Date
    
    init(accessToken: String, refreshToken: String, tokenExpirationDate: Date) {
        self._accessToken = accessToken
        self._refreshToken = refreshToken
        self._tokenExpirationDate = tokenExpirationDate
    }
    
    var accessToken: String {
        return _accessToken
    }
    
    var refreshToken: String {
        return _refreshToken
    }
    
    var tokenExpirationDate: Date {
        return _tokenExpirationDate
    }
    
    var shouldRefreshToken: Bool {
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= _tokenExpirationDate
    }
}
