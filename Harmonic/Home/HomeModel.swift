import Foundation

protocol HomeModelDelegate: AnyObject {
    func didReceiveRecentTracks()
    func didReceiveNewReleases()
}

class HomeModel {
    private let trackService: TrackServiceProtocol
    private let albumService: AlbumServiceProtocol
    var profile: UserProfile?
    var recentTracks: [TrackDetail] = []
    var latestAlbums: [Album] = []
    weak var delegate: HomeModelDelegate?
    
    init(trackService: TrackServiceProtocol = TrackService(), 
         albumService: AlbumServiceProtocol = AlbumService(),
         profile: UserProfile? = nil) {
        self.trackService = trackService
        self.albumService = albumService
        self.profile = profile
    }
    
    func getRecentlyPlayedTracks() {
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at home page fetch recent tracks")
                return
            }
            
            _ = self?.trackService.getRecentTracks(with: session.accessToken) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if let recentTracks = response.items?.map({ $0.track }) {
                            self?.recentTracks = recentTracks.uniqued()
                            self?.delegate?.didReceiveRecentTracks()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func getNewReleases() {
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at home page to fetch new releases")
                return
            }
            
            _ = self?.albumService.getNewReleases(with: session.accessToken) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let latestAlbums = response.albums.items
                        self?.latestAlbums = latestAlbums
                        self?.delegate?.didReceiveNewReleases()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
