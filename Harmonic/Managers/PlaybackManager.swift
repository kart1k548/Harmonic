import UIKit

final class PlaybackManager {
    private let urlManager = URLManager()
    
    private init() { }
    
    static func presentPlayer(from viewController: UIViewController, track: TrackDetail, albumImageUrl: String? = nil) {
        guard let webURL = URL(string: track.externalUrls.spotify),
              let appURL = URL(string: track.uri) else { return }
        
        let playerVC = PlayerViewController()
        let playerService = PlayerService(webURL: webURL, appURL: appURL)
        playerVC.presenter = PlayerPresenter(view: playerVC, model: .init(playerService: playerService, track: track, albumImageUrl: albumImageUrl))

        viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
    }
    
    static func presentPlayer(from viewController: UIViewController, tracks: [TrackDetail], albumImageUrl: String? = nil) {
        guard let track = tracks.first,
              let webURL = URL(string: track.externalUrls.spotify),
              let appURL = URL(string: track.uri) else { return }
        
        let playerVC = PlayerViewController()
        let playerService = PlayerService(webURL: webURL, appURL: appURL)
        playerVC.presenter = PlayerPresenter(view: playerVC, model: .init(playerService: playerService, tracksList: tracks, track: track, albumImageUrl: albumImageUrl))
        
        viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
    }
}
