import Foundation

protocol TabBarModelDelegate: AnyObject {
    func didReceiveProfile(profile: UserProfile?)
}

class TabBarModel {
    private let profileService: ProfileServiceProtocol
    
    weak var delegate: TabBarModelDelegate?
    
    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
    }
    
    func getUserProfile() {
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at home page")
                return
            }
            
            _ = self?.profileService.getUserProfile(with: session.accessToken) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self?.delegate?.didReceiveProfile(profile: profile)
                    case .failure(_):
                        self?.delegate?.didReceiveProfile(profile: nil)
                    }
                }
            }
        }
    }
}
