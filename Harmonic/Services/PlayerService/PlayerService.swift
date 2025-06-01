import Foundation
import AVFoundation

protocol PlayerServiceProtocol {
    func play()
    func pause()
}

struct PlayerService: PlayerServiceProtocol {
    private var player: AVPlayer
    private let urlManager: URLManagerProtocol
    private let webURL: URL
    private let appURL: URL
    
    init(webURL: URL, appURL: URL, urlManager: URLManagerProtocol = URLManager()) {
        self.player = AVPlayer(url: webURL)
        self.appURL = appURL
        self.webURL = webURL
        self.urlManager = urlManager
    }
    
    func play() {
        urlManager.openSpotifyTrack(appURL: appURL, webURL: webURL)
        player.play()
    }
    
    func pause() {
        player.pause()
    }
}
