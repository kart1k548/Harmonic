import UIKit

protocol URLManagerProtocol {
    func openSpotifyTrack(appURL: URL, webURL: URL)
}

class URLManager {
    private let urlOpener: URLOpener

    init(urlOpener: URLOpener = UIApplication.shared) {
        self.urlOpener = urlOpener
    }
}

extension URLManager: URLManagerProtocol {
    func openSpotifyTrack(appURL: URL, webURL: URL) {
        if urlOpener.canOpenURL(appURL) {
            urlOpener.open(appURL)
        } else {
            urlOpener.open(webURL)
        }
    }
}
